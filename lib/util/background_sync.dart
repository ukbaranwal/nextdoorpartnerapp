import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:nextdoorpartner/bloc/background_sync_bloc.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/models/product_category_model.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/util/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundSync {
  static BackgroundSyncBloc backgroundSyncBloc = BackgroundSyncBloc();
  static SharedPreferences sharedPreferences;

  Future<SendPort> initializeIsolate(Function callback) async {
    Completer completer = Completer<SendPort>();
    ReceivePort receivePort = ReceivePort();
    sharedPreferences = await SharedPreferencesManager.getInstance();
    await Isolate.spawn(syncData, receivePort.sendPort);
    receivePort.listen((message) {
      if (message is SendPort) {
        message.send(sharedPreferences);
      } else if (message is List<ProductCategoryModel>) {
        backgroundSyncBloc.insertProductCategoriesInDb(message);
      } else if (message is List<NotificationModel>) {
        callback(message.length);
        backgroundSyncBloc.insertNotificationsInDb(message);
        receivePort.close();
      }
    }, onDone: () {
      print('Done');
    });
    return completer.future;
  }

  static syncData(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      if (message is SharedPreferences) {
        print(message.getInt(SharedPreferencesManager.vendorType));
        ApiResponse<dynamic> response =
            await backgroundSyncBloc.syncProductCategories(
                message.getInt(SharedPreferencesManager.vendorType));
        if (response.status == Status.HAS_DATA) {
          List<ProductCategoryModel> productCategoryModelList =
              List<ProductCategoryModel>();
          for (var i in response.data) {
            productCategoryModelList.add(ProductCategoryModel.fromJson(i));
          }
          sendPort.send(productCategoryModelList);
        }
        response = await backgroundSyncBloc.syncNotifications(
            message.getString(SharedPreferencesManager.authorisationToken));
        if (response.status == Status.HAS_DATA) {
          List<NotificationModel> notificationModelList =
              List<NotificationModel>();
          for (var i in response.data) {
            notificationModelList.add(NotificationModel.fromJson(i));
          }
          sendPort.send(notificationModelList);
        }
        receivePort.close();
      }
    });
  }
}

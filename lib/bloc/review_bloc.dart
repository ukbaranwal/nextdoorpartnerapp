import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/product_model.dart';
import 'package:nextdoorpartner/models/review_model.dart';
import 'package:nextdoorpartner/resources/api_response.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ReviewsBloc implements BlocInterface {
  bool alreadyExecuting = false;
  final _repository = Repository();
  var _reviewsFetcher = PublishSubject<ApiResponse<List<ReviewModel>>>();
  List<ReviewModel> reviewsModelList;
  Stream<ApiResponse<List<ReviewModel>>> get reviewsStream =>
      _reviewsFetcher.stream;
  int selectedRating = -1;

  ReviewsBloc() {
    reviewsModelList = List<ReviewModel>();
  }

  getReviews({int rating}) async {
    if (alreadyExecuting) {
      return;
    }
    try {
      if (rating != selectedRating) {
        print(selectedRating);
        selectedRating = rating;
        reviewsModelList = List<ReviewModel>();
      }
      alreadyExecuting = true;
      Response response =
          await _repository.getReviews(reviewsModelList.length, selectedRating);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse.toString());
        if (jsonResponse['data']['reviews']['rows'].length == 0) {
          _reviewsFetcher.sink.add(ApiResponse.hasData('end', data: {
            'noOfReviews': jsonResponse['data']['reviews']['count'],
            'reviewsList': reviewsModelList
          }));
          alreadyExecuting = false;
          return;
        }
        for (var i in jsonResponse['data']['reviews']['rows']) {
          print(i);
          reviewsModelList.add(ReviewModel.fromJson(i));
        }
        _reviewsFetcher.sink.add(ApiResponse.hasData('done', data: {
          'noOfReviews': jsonResponse['data']['reviews']['count'],
          'reviewsList': reviewsModelList
        }));
      }
      alreadyExecuting = false;
    } catch (e) {
      print(e);
      _reviewsFetcher.sink.add(ApiResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _reviewsFetcher.close();
  }
}

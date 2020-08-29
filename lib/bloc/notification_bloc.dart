import 'package:nextdoorpartner/bloc/bloc_interface.dart';
import 'package:nextdoorpartner/models/notification_model.dart';
import 'package:nextdoorpartner/resources/db_operation_response.dart';
import 'package:nextdoorpartner/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationBloc implements BlocInterface{
  final _repository = Repository();
  var _notificationFetcher = PublishSubject<DbResponse<List<NotificationModel>>>();
  Stream<DbResponse<List<NotificationModel>>> get notificationStream =>
      _notificationFetcher.stream;

  insertNotificationInDb(NotificationModel notificationModel) async {
    try {
      await _repository.insertNotificationInDb(notificationModel);
    } catch (e) {
      print(e.toString());
      return DbResponse.error(e.toString());
    }
  }

  getNotifications() async{
    _notificationFetcher = PublishSubject<DbResponse<List<NotificationModel>>>();
    try {
      _notificationFetcher.sink.add(DbResponse.loading('Checking'));
      List<NotificationModel> data = await _repository.getNotifications();
      _notificationFetcher.sink.add(DbResponse.successful('Done', data: data));
    } catch (e) {
      print(e.toString());
      _notificationFetcher.sink.add(DbResponse.error(e.toString()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _notificationFetcher.close();
  }


}

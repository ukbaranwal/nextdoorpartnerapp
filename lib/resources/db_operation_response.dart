class DbResponse<T> {
  DBStatus status;
  dynamic data;
  String message;

  DbResponse.loading(this.message) : status = DBStatus.LOADING;
  DbResponse.successful(this.message, {this.data})
      : status = DBStatus.SUCCESSFUL;
  DbResponse.error(this.message) : status = DBStatus.ERROR;

  @override
  String toString() {
    return "Status : $status  Message : $message  Data : $data";
  }
}

enum DBStatus { LOADING, SUCCESSFUL, ERROR }

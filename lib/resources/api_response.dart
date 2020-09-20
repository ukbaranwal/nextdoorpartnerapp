class ApiResponse<T> {
  Status status;
  dynamic data;
  String message;
  ApiActions actions;
  LOADER loader;
  ApiResponse.hasData(this.message, {this.data, this.actions, this.loader})
      : status = Status.HAS_DATA;
  ApiResponse.error(this.message, {this.actions, this.loader})
      : status = Status.ERROR;
  ApiResponse.socketError({this.actions, this.loader})
      : status = Status.SOCKET_ERROR;

  @override
  String toString() {
    return "Status : $status  Message : $message  Data : $data";
  }
}

enum Status { HAS_DATA, ERROR, SOCKET_ERROR }

enum ApiActions {
  LOADING,
  INITIATED,
  SUCCESSFUL,
  ERROR,
}

enum LOADER { SHOW, HIDE, IDLE }

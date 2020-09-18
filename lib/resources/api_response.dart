class ApiResponse<T> {
  Status status;
  dynamic data;
  String message;
  bool showToast;
  bool showLoader;
  ApiResponse.hasData(this.message,
      {this.data, this.showToast = false, this.showLoader = false})
      : status = Status.HAS_DATA;
  ApiResponse.loading(this.message, {this.data}) : status = Status.LOADING;
  ApiResponse.successful(this.message, {this.data, this.showToast = false})
      : status = Status.SUCCESSFUL;
  ApiResponse.unSuccessful(this.message) : status = Status.UNSUCCESSFUL;
  ApiResponse.validationFailed(this.message)
      : status = Status.VALIDATION_FAILED;
  ApiResponse.error(this.message,
      {this.showToast = true, this.showLoader = false})
      : status = Status.ERROR;
  ApiResponse.socketError({this.showToast = false, this.showLoader = false})
      : status = Status.SOCKET_ERROR;

  @override
  String toString() {
    return "Status : $status  Message : $message  Data : $data";
  }
}

enum Status {
  LOADING,
  HAS_DATA,
  SUCCESSFUL,
  UNSUCCESSFUL,
  ERROR,
  VALIDATION_FAILED,
  SOCKET_ERROR
}

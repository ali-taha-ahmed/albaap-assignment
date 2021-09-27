class HTTPResponse<T> {
  bool isSuccessful;
  T? data;
  String? message;
  HTTPResponse({required this.isSuccessful, this.data, this.message});
}

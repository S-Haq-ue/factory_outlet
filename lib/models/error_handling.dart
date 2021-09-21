class ErrorHandler implements Exception {
  final String errorText;
  ErrorHandler(this.errorText);

  @override
  String toString() {
    return errorText;
  }
}

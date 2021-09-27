import 'package:flutter/foundation.dart';

class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "http://quotes.stormconsultancy.co.uk";
    } else {
      return "http://quotes.stormconsultancy.co.uk";
    }
  }
}

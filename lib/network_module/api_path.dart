enum APIPath {
  fetchQuotes,
}

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.fetchQuotes:
        return "/random.json";

      default:
        return "";
    }
  }
}

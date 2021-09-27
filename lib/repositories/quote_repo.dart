import 'package:quotes_app/models/quote_model.dart';
import 'package:quotes_app/network_module/api_path.dart';
import 'package:quotes_app/network_module/api_response.dart';
import 'package:quotes_app/network_module/http_client.dart';

class QuoteRepository {
  static Future<HTTPResponse<QuoteModel>> fetchQuote() async {
    try {
      final response = await HttpClient.instance
          .fetchData(url: APIPathHelper.getValue(APIPath.fetchQuotes));
      if (response != null) {
        return HTTPResponse(
            isSuccessful: true, data: QuoteModel.fromJson(response));
      } else {
        return HTTPResponse(
            isSuccessful: false,
            message: "something went wrong please try later");
      }
    } catch (e) {
      rethrow;
    }
  }
}

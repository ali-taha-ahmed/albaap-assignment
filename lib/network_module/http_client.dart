import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'api_base.dart';
import 'api_exceptions.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData(
      {required String url,
      Map<String, String>? params,
      String token = ''}) async {
    dynamic responseJson;
    var uri = Uri.parse(APIBase.baseURL + url + queryParameters(params));
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    try {
      final response = await http.get(uri, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  String queryParameters(Map<String, String>? params) {
    final jsonString = Uri(queryParameters: params);
    return '?${jsonString.query}';
  }

  Future<dynamic> postData(
      {required String url, @required dynamic body, String token = ''}) async {
    dynamic responseJson;
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    try {
      final response = await http.post(Uri.parse(APIBase.baseURL + url),
          body: body, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putData(
      {required String url,
      dynamic body,
      Map<String, String>? params,
      String token = ''}) async {
    var uri = Uri.parse(APIBase.baseURL + url + queryParameters(params));
    dynamic responseJson;
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    try {
      final response = await http.put(uri, body: body, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> deleteData(String url,
      {required Map<String, String> params, String token = ''}) async {
    dynamic responseJson;
    var uri = Uri.parse(APIBase.baseURL + url + queryParameters(params));
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token
    };
    try {
      final response = await http.delete(uri, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        var responseJson = jsonDecode(response.body);
        throw BadRequestException(responseJson);
      case 401:
      case 403:
        throw UnauthorizedException(response.body);
      case 404:
        if (response.body.isNotEmpty) {
          var responseJson = jsonDecode(response.body);
          return responseJson;
        }
        throw NotFoundException(
            'Request was not found StatusCode : ${response.statusCode}');

      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

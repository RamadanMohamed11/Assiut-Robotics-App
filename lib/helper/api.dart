import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class API {
  Future<Map<String, dynamic>> get({required String url, String? token}) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'There is an error in fetching data ${response.statusCode}',
      );
    }
  }

  Future<dynamic> post({
    required String url,
    @required Map<String, String>? body,
    @required String? token,
  }) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }
    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 400) {
      throw Exception('${jsonDecode(response.body)['message']}');
    } else if (response.statusCode == 404) {
      throw Exception('${jsonDecode(response.body)['message']}');
    } else if (response.statusCode == 500) {
      throw Exception('${jsonDecode(response.body)['message']}');
    } else {
      throw Exception(
        'There is an error in fetching data ${response.statusCode}',
      );
    }
  }

  Future<dynamic> put({
    required String url,
    @required Map<String, String>? body,
    @required String? token,
  }) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }
    http.Response response = await http.put(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
        'There is an error in fetching data ${response.statusCode}',
      );
    }
  }
}

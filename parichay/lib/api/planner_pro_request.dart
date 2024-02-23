import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parichay/key.dart';

Future<void> _getRequest(String prompt) async {
  var _response;
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GPTKey.GapiKey}';
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  try {
    var query = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(query),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _response = result['candidates'][0]['content']['parts'][0]['text'];
    } else {
      _response = 'Error occurred $response';
    }
  } catch (e) {
    _response = 'Error occurred $e';
  }
}

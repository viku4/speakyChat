import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:speaky_chat/main.dart';
import 'package:speaky_chat/data/const/api_urls.dart';
import 'package:speaky_chat/components/custom_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speaky_chat/flutter_flow/flutter_flow_util.dart';

class Api {
  static final authHeader = {'accept': "application/json"};
  static final commonHeader = {
    "AUTHORIZATION": preferences.getString('token') ?? '',
  };

  Dio api = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
    ),
  );
  Future<dynamic> request({
    required String url,
    required RequestMethod method,
    Object? payload,
    bool? showLoader,
    bool? showSnackbar,
    required Map<String, dynamic> header,
    bool? showLogs,
  }) async {
    if (showLoader ?? true) {
      showLoading();
    }

    // header['Authorization'] = 'Bearer ${loginProvider.authToken}';
    if (showLogs ?? false) {
      log("Request url-- $baseUrl${url}");
      // log("AccessToken-- ${loginProvider.authToken ?? ""}");
      log("loading-- ${showLoader}");
      log("logs-- ${showLogs}");
      log("header-- ${header}");
      if (payload is FormData) {
        log("Request Body-- ${payload.fields} ${payload.files}");
      } else {
        log("Request Body-- ${payload}");
      }
    }

    try {
      Response<dynamic> response;
      switch (method) {
        case RequestMethod.get:
          response = await api.get(url,
              data: payload, options: Options(headers: header));
          break;
        case RequestMethod.post:
          response = await api.post(url,
              data: payload, options: Options(headers: header));
          break;
        case RequestMethod.patch:
          response = await api.patch(url,
              data: payload, options: Options(headers: header));
          break;
        case RequestMethod.delete:
          response = await api.delete(url, options: Options(headers: header));
          break;
      }

      if (showLogs ?? false) {
        log('API request successful:-- ${response.statusCode}');
        log('Response data:-- ${response}'); // Consider handling sensitive data
      }
      if (showLoader ?? true) {
        Navigator.pop(MyApp.navigatorKey.currentContext!);
      }

      if ((response.data["result"]["status"] == 200) ||
          (response.data["result"]["status"] == 201)) {
        if ((response.data["result"]["message"] != "") &&
            (response.data["result"]["message"] != null) &&
            (showSnackbar ?? false)) {
          // showCustomSnacbar(
          //   title: "Yeah!",
          //   message: response.data["result"]["message"],
          //   contentType: ContentType.success,
          // );
        }
        return response.data["result"]["response"];
      } else {
        if ((response.data["result"]["message"] != "") &&
            (response.data["result"]["message"] != null) &&
            (showSnackbar ?? false)) {
          // showCustomSnacbar(
          //   title: "Opps!",
          //   message: response.data["result"]["message"],
          //   contentType: ContentType.failure,
          // );
        }
      }

      return null;
      // }
    } on DioError catch (e) {
      if (showLoader ?? true) {
        Navigator.pop(MyApp.navigatorKey.currentContext!);
      }
      // showCustomSnacbar(
      //   title: "Opps!",
      //   message: "Internal server error",
      //   contentType: ContentType.failure,
      // );
      log('API request error: ${e.type}, ${e.message}');

      // Or re-throw a custom exception with more context
    }
  }
}

enum RequestMethod { get, post, patch, delete }

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:as_toast_x/extensions.dart';
import 'package:crm/model/audio_response.dart';
import 'package:crm/utils/local_notification.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

import '../model/base_model.dart';
import '../model/login_response.dart';
import '../utils/constants.dart';

class ApiService {
  var dio = Dio();

  ApiService() {
    // dio.options.baseUrl = "http://${PrefUtils.getIp()}/api/v1/";
     dio.options.baseUrl = BASE_URL; //PrefUtils.getBaseUrl();
    // dio.options.baseUrl =
    //     "http://${PrefUtils.getIpAddress()}:${PrefUtils.getIpPort()}/api/v1/mobile/";
    // dio.options.headers['Content-Type'] = 'application/json';
    // dio.options.headers['type'] = 'mobile';
    // dio.options.headers["Accept"] = "application/json";
    // dio.options.headers["X-Mobile-Type"] = "android";

    // dio.options.headers["authorization"] = "Basic bW9iaWxlczoxMjM=";
     dio.options.headers["Authorization"] =
        "Bearer ${
            (PrefUtils.getUser()?.token??"")+""
            // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMiIsImlhdCI6MTY4MzQ2ODEyNH0.CR0zXInJG4sLx4CozN8ynAhj2JfHX4gfeR5qPIzJs8I"
        }"; ////Bearer ${PrefUtils.getToken()}
     dio.options.headers["mobile"] =1;
     // dio.interceptors.add(MyApp.alice.getDioInterceptor());

    // dio.options.headers.addAll({
    //   'token': "",
    //   'device': Platform.operatingSystem,
    //   'mobile': 1
    // });
  }

  BaseModel wrapResponse(Response response) {
    if (response.statusCode == 200) {
      final data = BaseModel.fromJson(response.data);
      if (!data.error) {
        return data;
      } else {
        if (data.error_code == 401) {
          // getIt<EventBus>().fire(EventModel(event: EVENT_LOG_OUT, data: 0));
          LocalNotification.showNotification("Sizning profilingizdan kirishgan", "Iltomos qaytadan kiring", true);
          PrefUtils.clearAll();
          Future.delayed(5.seconds,(){
            exit(0);
          });
        }
      }
      return data;
    } else {
      return BaseModel(false, response.statusMessage ?? "Unknown error ${response.statusCode}", -1, null);
    }
  }

  String? wrapError(DioError error) {
    if (kDebugMode) {
      return error.message;
    }
    switch (error.type) {
      case DioErrorType.other:
        return "Network error.";
      case DioErrorType.cancel:
        return "Unknown error.";
      case DioErrorType.connectTimeout:
        return "Unknown error.";
      case DioErrorType.receiveTimeout:
        return "Unknown error.";
      case DioErrorType.sendTimeout:
        return "Unknown error.";
      case DioErrorType.response:
        return "Unknown error.";
    }
  }

  Future<AudioResponse?> sendAudio(String filePath,String phone,int date, StreamController<String> errorStream) async {
    try {
      final mimeTypeData = lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])?.split('/');
      final response = await dio.post(
        "record/audio",
        data: FormData.fromMap(
          {
            "phone_number": phone.replaceAll("+", ""),
            "time": date,
            "audio": await MultipartFile.fromFile(
              filePath,
              filename: filePath.split("/").last,
              contentType: MediaType(
                  //mimeTypeData?[0] ?? "audio", mimeTypeData?[1] ?? "m4a")
                  "audio",
                  filePath.split("/").last.split(".").last),
            ),
          },
        ),
      );

      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return AudioResponse.fromJson(baseData.data);
        //(baseData.data as List<dynamic>).map((json) => TaskModel.fromJson(json)).toList();
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioError catch (e) {
      errorStream.sink.add(e.message ?? e.stackTrace.toString());
    }
    return null;
  }

  //login
  Future<LoginResponse?> login(
  String username, String password, StreamController<String> errorStream) async {
    try {
      final response = await dio.post("user/login",
          //queryParameters: {"phone": phone}
          data: jsonEncode(
              {
                "username":username,
                "password": password,
              }));
      final baseData = wrapResponse(response);
      if (!baseData.error) {
        return LoginResponse.fromJson(baseData.data);
      } else {
        errorStream.sink.add(baseData.message ?? "Error");
      }
    } on DioError catch (e) {
      errorStream.sink.add(wrapError(e).toString());
    }
    return null;
  }

}

//Future<void> uploadImage(String title, File file) async {
//         var request =await http.MultipartRequest("POST", Uri.parse("https://api.imgur.com/3/image"));
//         request.fields["title"] = title;
//         request.headers["Authorization"] = "";
//         var picture = http.MultipartFile.fromBytes('image', (await rootBundle.load('assets/testimage.png')).buffer.asUint8List(),
//         filename: 'image.png');
//         request.files.add(picture);
//         var response = await request.send();
//         var responseData = await response.stream.toBytes();
//         var result = String.fromCharCodes(responseData);
//         print(result);
//      }

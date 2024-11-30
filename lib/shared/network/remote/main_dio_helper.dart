import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../end_points.dart';

// Dio is an HTTP client, we declare in the init() giving the url to get the data from, and it getData we give him the method and queries.
class MainDioHelper
{
  static Dio ? dio;

  static init() async
  {
    dio=Dio(
      BaseOptions(
        baseUrl: localhost,
        receiveDataWhenStatusError: true,
        // receiveTimeout: Duration.zero, //50000,
        // connectTimeout: Duration.zero, //30000,
        // validateStatus: (status)=>true, //Won't throw errors
      ),

    );

  }

  static void setBaseUrl(String url)
  {
    dio?.options.baseUrl=url;
  }

  static Future<Response> getData({required String url,  Map<String,dynamic>? query, Map<String,dynamic>? data, String lang='en', String? token,}) async
  {
    dio?.options.headers=
    {
      'Accept':'application/json',
      'Connection' : 'keep-alive',
      'Authorization': 'Bearer $token',
    };

    //print('in Main Dio getData');
    return await dio!.get(
      url,
      queryParameters: query,
      data: data,
    ); //path is the method
  }


  static Future<Response> postData(
      {required String url, Map<String,dynamic>?query,  required Map<String,dynamic> data, String lang='en', String? token, bool isStatusCheck=false, List<int>? statusCodes, String? baseUrl}) async
  {
    if(baseUrl!=null)
      {
        dio?.options.baseUrl=baseUrl;
      }
    dio?.options.headers=
      {
        'Accept':'application/json',
        'Connection' : 'keep-alive',
        'Authorization': 'Bearer $token',
      };

    if(isStatusCheck == true)  //Allow Status 400,200,201 for Register and Login Errors.
      {
        dio?.options.validateStatus= (status) {
          if(statusCodes !=null? statusCodes.contains(status) : [200,201,400,404].contains(status))
          {
            return true;
          }
          else
          {
            return false;
          }
        };
      }

    //print('in Main Dio postData');
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }


  static Future<Response> postFileData(
      {required String url, Map<String,dynamic>?query,  required dynamic data, String lang='en', String? token, void Function(int, int)? onSendProgress }) async
  {
    dio?.options.headers=
    {
      'Accept':'application/json',
      'Connection' : 'keep-alive',
      'Authorization': 'Bearer $token',
    };

    //print('in Main Dio postData');
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
      onSendProgress: onSendProgress,
    );
  }


  static Future<Response> putData(
      {required String url, Map<String,dynamic>?query,  required Map<String,dynamic> data, String lang='en', String? token, bool isStatusCheck=false }) async
  {
    dio?.options.headers=
    {
      'Accept':'application/json',
      'Connection' : 'keep-alive',
      'Authorization': 'Bearer $token',
    };

    if(isStatusCheck == true)  //Allow Status 400,200,201 for Register and Login Errors.
    {
      dio?.options.validateStatus= (status) {
        if([200,201,400].contains(status))
        {
          return true;
        }
        else
        {
          return false;
        }
      };
    }

    //print('in Main Dio putData');
    return await dio!.put(
      url,
      queryParameters: query,
      data: data,
    );
  }


  static Future<Response> patchData(
      {required String url, Map<String,dynamic>?query,  required Map<String,dynamic> data, String lang='en', String? token, bool isStatusCheck=false}) async
  {
    dio?.options.headers=
    {
      'Accept':'application/json',
      'Connection' : 'keep-alive',
      'Authorization': 'Bearer $token',
    };

    if(isStatusCheck == true)  //Allow Status 400,200,201 for Register and Login Errors.
    {
      dio?.options.validateStatus= (status) {
        if([200,201,400].contains(status))
        {
          return true;
        }
        else
        {
          return false;
        }
      };
    }


    //print('in Main Dio patchData');
    return await dio!.patch(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> deleteData({required String url, Map<String,dynamic>?query,  required Map<String,dynamic> data, String? token, bool isStatusCheck=false})
  async {
    dio?.options.headers=
    {

      'Accept' : 'application/json',
      'Authorization': 'Bearer $token',
    };

    if(isStatusCheck == true)  //Allow Status 400,200,201 for Register and Login Errors.
        {
      dio?.options.validateStatus= (status) {
        if([200,201,400].contains(status))
        {
          return true;
        }
        else
        {
          return false;
        }
      };
    }

    //print('in Main Dio deleteData');
    return await dio!.delete(
      url,
      data: data,
      queryParameters: query,
    );
  }



}
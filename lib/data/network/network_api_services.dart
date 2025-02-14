import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:youbloomdemo/data/network/base_api_services.dart';

import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {


  @override
  Future<dynamic> getApi(String url)async{
    dynamic responseJson ;
    try {

      final response = await http.get(Uri.parse(url)).timeout( const Duration(seconds: 15));
      responseJson  = returnResponse(response) ;
    }on SocketException {
      throw InternetException('');
    }on RequestTimeOut {
      throw RequestTimeOut('');

    }
    return responseJson ;

  }


  @override
  Future<dynamic> postApi(var data , String url)async{
    dynamic responseJson ;
    try {
      final response = await http.post(Uri.parse(url),
        body: data
      ).timeout( const Duration(seconds: 15));
      responseJson  = returnResponse(response) ;
    }on SocketException {
      throw InternetException('');
    }on RequestTimeOut {
      throw RequestTimeOut('');

    }
    return responseJson ;

  }

  dynamic returnResponse(http.Response response){
    switch(response.statusCode){
      case 200 || 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson ;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson ;
      case 401:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson ;

      default :
        throw FetchDataException('Error accoured while communicating with server '+response.statusCode.toString()) ;
    }
  }

}
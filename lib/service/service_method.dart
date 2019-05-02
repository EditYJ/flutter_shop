import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';

import '../config/service_url.dart';

Future getHomePageData() async{
  Response response;
  Dio dio = new Dio();
  dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
  var formData = {'lon':'115.02932','lat':'35.76189'};
  try {
    print('开始获取数据............');
    response = await dio.post(servicePath['homePageContext'], data: formData);
    return response.data;
  } catch (e) {
    return print(e);
  }
}
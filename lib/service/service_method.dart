import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';

import '../config/service_url.dart';

///网络请求 
///
///`urlKey`: service_url中的API地址的键 
///
///`requestData`: 请求数据
Future request(urlKey, {requestData}) async{
  Response response;
  Dio dio = new Dio();
  dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
  try {
    print('开始获取=urlKey=为【${urlKey}】的数据............');
    if(requestData!=null)
      response = await dio.post(servicePath[urlKey], data: requestData);
    else
      response = await dio.post(servicePath[urlKey]);
    return response.data;
  } catch (e) {
    return print(e);
  }
}


// ///获取主页json数据
// Future getHomePageData() async{
//   Response response;
//   Dio dio = new Dio();
//   dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
//   var formData = {'lon':'115.02932','lat':'35.76189'};
//   try {
//     print('开始获取数据............');
//     response = await dio.post(servicePath['homePageContext'], data: formData);
//     return response.data;
//   } catch (e) {
//     return print(e);
//   }
// }

// ///拉取首页火热商品列表
// Future getHomePageBelowContent() async{
//   Response response;
//   Dio dio = new Dio();
//   dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
//   try {
//     print('开始获取火爆专区数据............');
//     response = await dio.post(servicePath['homePageBelowContent'], data: 1);
//     return response.data;
//   } catch (e) {
//     return print(e);
//   }
// }
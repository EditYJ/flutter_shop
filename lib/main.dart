///程序主入口
import 'package:flutter/material.dart';
import './pages/index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        ///是否取出debug标识
        debugShowCheckedModeBanner: false,
        ///设置粉色主题
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        ///指定页面入口
        home: IndexPage(),
      ),
    );
  }
}
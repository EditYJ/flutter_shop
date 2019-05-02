/// 首页页面
import 'package:flutter/material.dart';
import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textContent = 'welcome welcome welcome!';

  @override
  void initState() {
    getHomePageData().then((val) {
      setState(() {
        textContent = val.toString();
        print(val.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: SingleChildScrollView(
        child: Text(textContent),
      ),
    );
  }
}

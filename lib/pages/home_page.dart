/// 首页页面
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  String textContent= 'welcome welcome welcome!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test dio'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            autofocus: false,
            controller: textEditingController,
            decoration: InputDecoration(
                labelText: 'name',
                helperText: 'input name',
                contentPadding: EdgeInsets.all(10.0)),
          ),
          RaisedButton(
            child: Text('send and check'),
            onPressed: () {
              showResult(textEditingController.text.toString());
            },
          ),
          Text(
            textContent,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  void showResult(String name){
    print('...get data...');
    getHttp(name).then((value){
      setState(() {
        textContent = value['data']['name'].toString();
      });
    });
  }
  

  Future getHttp(String name) async {
    try {
      Response response;
      var data = {'name': name};
      response = await Dio().get(
        'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian',
        queryParameters: data,
      );
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}

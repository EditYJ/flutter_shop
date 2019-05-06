/// 购物车页面
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class ShopCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Number(),
          AddNumButton()
        ],
      )
    );
  }
}

class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 300.0),
      child: Provide<Counter>(
        builder: (context, child, counter){
          return Text(
            '${counter.number}',
            style: Theme.of(context).textTheme.display1,
          );
        },
      )
      
      
    );
  }
}

class AddNumButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: (){
          Provide.value<Counter>(context).addNumber();
        },
        child: Text("点击增加"),
      ),
    );
  }
}
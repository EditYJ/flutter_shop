/// 会员中心
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReadNumber(),
    );
  }
}
class ReadNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 300.0),
      child: Provide<Counter>(
        builder:(context, child, counter){
          return Text(
            '${counter.number}',
            style: Theme.of(context).textTheme.display1,
          );
        }
      ),
    );
  }
}
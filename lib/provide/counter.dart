///测试状态管理器
import 'package:flutter/material.dart';

class Counter with ChangeNotifier{
  int number = 0;
  addNumber(){
    number++;
    notifyListeners();
  }
}
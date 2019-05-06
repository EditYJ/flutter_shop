/// 分类页面
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import '../model/category.dart';


class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<MainCategoryData> mainCategoryDataList = [];

  @override
  void initState() {
    _getCategoryData();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("百姓生活+"),),
      body: Container(
        child: Row(
          children: <Widget>[
            _firstCategory(),
          ],
        ),
      ),
    );
  }

  void _getCategoryData() async {
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        mainCategoryDataList =  category.data;
      });
    });
  }

  Widget _firstCategoryItem(index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(100),
        alignment: Alignment.centerLeft, 
        padding: EdgeInsets.only(left: 7.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.black12))
        ),
        child: Text(mainCategoryDataList[index].mallCategoryName, style: TextStyle(fontSize: ScreenUtil().setSp(26.0)),),
      ),
    );
  }

  Widget _firstCategory(){
    return Container(
      width: ScreenUtil().setWidth(180.0),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1.0, color: Colors.black12))
      ),
      child: ListView.builder(
        itemCount: mainCategoryDataList.length,
        itemBuilder: (context,index){
          return _firstCategoryItem(index);
        },
      ),
    );
  }
}


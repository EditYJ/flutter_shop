/// 主页内容
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
///引入页面文件 
import 'home_page.dart';
import 'category_page.dart';
import 'shopcart_page.dart';
import 'member_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  ///底部标签菜单栏中的每一项所组成的数组
  final List<BottomNavigationBarItem> bottomItemList = [
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home,), title: Text("首页")),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search,), title: Text("分类")),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart,), title: Text("购物车")),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_solid,), title: Text("会员中心")),
  ];
  ///页面数组，对应底部菜单栏的每一项
  final List<Widget> pageList=[
    HomePage(),
    CategoryPage(),
    ShopCartPage(),
    MemberPage(),
  ];

  int currentIndex = 0;   // 当前页面索引
  Widget currentPage;   // 当前页面

  @override
  void initState() {
    /// 初始化currentPage，依据currentIndex设定开始显示的页面
    currentPage = pageList[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //初始化屏幕适配插件
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomItemList,
        currentIndex: currentIndex,
        /// 底部导航栏的点击事件，依据回调函数传回的index值
        /// 通过setState设定currentIndex和currentPage的值
        /// 动态改变当前显示页面
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = pageList[index];
          });
        },
      ),
      body: currentPage,
    );
  }
}

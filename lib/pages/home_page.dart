/// 首页页面
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textContent = 'welcome welcome welcome!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        future: getHomePageData(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            //json总数据的获取
            var data = json.decode(snapshot.data.toString());
            //轮播图数据解析
            List<Map> swiperData = (data['data']['slides'] as List).cast(); //强转类型
            //中上部导航数据解析
            List<Map> homeNavigationListData = (data['data']['category'] as List).cast();
            //中部广告控件数据解析
            Map adData = (data['data']['advertesPicture']);

            //界面控件安放
            return Column(
              children: <Widget>[
                HomeTopSwiper(homeTopSwiperImgDataList: swiperData,),
                HomeNavigation(homeNavigationListData: homeNavigationListData,),
                HomeMiddleAd(adData: adData,)
              ],
            );
          } else {
            return Center(
              child: Text("正在加载..."),
            );
          }
        },
      )
    );
  }
}

///主页上部轮播图控件
class HomeTopSwiper extends StatelessWidget {
  final List homeTopSwiperImgDataList;
  HomeTopSwiper({Key key, this.homeTopSwiperImgDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return new Image.network(homeTopSwiperImgDataList[index]['image'], fit: BoxFit.fill,);
        },
        itemCount: homeTopSwiperImgDataList.length,
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }
}

///主页中上部导航控件
class HomeNavigation extends StatelessWidget {
  final List homeNavigationListData;
  const HomeNavigation({Key key, this.homeNavigationListData}) : super(key: key);

  ///导航中每一个小部件
  Widget _homeNavigationItem(BuildContext context, item){
    return Column(
      children: <Widget>[
        Image.network(item['image'], width: ScreenUtil().setWidth(95),),
        Text(item['mallCategoryName']),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if(homeNavigationListData.length > 10){
      homeNavigationListData.removeRange(10, homeNavigationListData.length);
    }
    return Container(
      // color: Colors.grey[100],
      height: ScreenUtil().setHeight(283.0),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: homeNavigationListData.map((item){
          return _homeNavigationItem(context, item);
        }).toList(),
      ),
    );
  }
}

///中部广告控件
class HomeMiddleAd extends StatelessWidget {
  final Map adData;
  const HomeMiddleAd({Key key, this.adData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adData['PICTURE_ADDRESS']),
    );
  }
}


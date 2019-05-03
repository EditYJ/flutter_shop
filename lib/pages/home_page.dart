/// 首页页面
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //json总数据的获取
              var data = json.decode(snapshot.data.toString());
              //轮播图数据解析
              List<Map> swiperData =
                  (data['data']['slides'] as List).cast(); //强转类型
              //中上部导航数据解析
              List<Map> homeNavigationListData =
                  (data['data']['category'] as List).cast();
              //中部广告控件数据解析
              Map adData = data['data']['advertesPicture'];
              //店长电话数据解析
              Map leaderPhoneNumberData = data['data']['shopInfo'];
              //推荐商品数据解析
              List<Map> recommendGoodsData =
                  (data['data']['recommend'] as List).cast();

              //界面控件安放
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    HomeTopSwiper(
                      homeTopSwiperImgDataList: swiperData,
                    ),
                    HomeNavigation(
                      homeNavigationListData: homeNavigationListData,
                    ),
                    HomeMiddleAd(
                      adData: adData,
                    ),
                    PlayLeaderPhone(
                      leaderPhoneData: leaderPhoneNumberData,
                    ),
                    RecommendGoods(
                      recommendGoodsData: recommendGoodsData,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text("正在加载..."),
              );
            }
          },
        ));
  }
}

///控件
///主页上部轮播图控件
class HomeTopSwiper extends StatelessWidget {
  final List homeTopSwiperImgDataList;
  HomeTopSwiper({Key key, this.homeTopSwiperImgDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            homeTopSwiperImgDataList[index]['image'],
            fit: BoxFit.fill,
          );
        },
        itemCount: homeTopSwiperImgDataList.length,
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }
}

///控件
///主页中上部导航控件
class HomeNavigation extends StatelessWidget {
  final List homeNavigationListData;
  const HomeNavigation({Key key, this.homeNavigationListData})
      : super(key: key);

  ///导航中每一个小部件
  Widget _homeNavigationItem(BuildContext context, item) {
    return Column(
      children: <Widget>[
        Image.network(
          item['image'],
          width: ScreenUtil().setWidth(95),
        ),
        Text(item['mallCategoryName']),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (homeNavigationListData.length > 10) {
      homeNavigationListData.removeRange(10, homeNavigationListData.length);
    }
    return Container(
      color: Colors.white,
      // alignment: Alignment.center,
      height: ScreenUtil().setHeight(320.0),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), //阻止滑动
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: homeNavigationListData.map((item) {
          return _homeNavigationItem(context, item);
        }).toList(),
      ),
    );
  }
}

///控件
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

///控件
///拨打店长电话控件
class PlayLeaderPhone extends StatelessWidget {
  final Map leaderPhoneData;
  const PlayLeaderPhone({Key key, this.leaderPhoneData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _toPlayPhone(leaderPhoneData['leaderPhone']);
        },
        child: Image.network(leaderPhoneData['leaderImage']),
      ),
    );
  }

  ///拨打电话的方法
  void _toPlayPhone(String phoneNumber) async {
    String phoneLaunchNumber = 'tel:' + phoneNumber;
    if (await canLaunch(phoneLaunchNumber)) {
      await launch(phoneLaunchNumber);
    } else {
      throw 'Can not play this URL...';
    }
  }
}

///控件
///热门推荐模块
class RecommendGoods extends StatelessWidget {
  final List recommendGoodsData;
  const RecommendGoods({Key key, this.recommendGoodsData}) : super(key: key);

  ///标题组件
  Widget _title(String titleName) {
    return Container(
      // height: ScreenUtil().setHeight(70.0),
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0,5.0),
      alignment: Alignment.centerLeft,
      // padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border: BorderDirectional(
            bottom: BorderSide(color: Colors.black12, width: 1.0)),
        color: Colors.white,
      ),
      child: Text(
        titleName,
        style: TextStyle(color: Colors.pink, fontSize: 16.0),
      ),
    );
  }

  ///列表项
  Widget _item(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
          height: ScreenUtil().setHeight(360),
          width: ScreenUtil().setWidth(250),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1.0),
              color: Colors.white),
          child: Column(
            children: <Widget>[
              Image.network(recommendGoodsData[index]['image']),
              Text('￥${recommendGoodsData[index]['mallPrice']}'),
              Container(
                height: 5.0,
              ),
              Text(
                '￥${recommendGoodsData[index]['price']}',
                style: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.lineThrough),
              ),
            ],
          )),
    );
  }

  ///横向列表
  Widget _crossList() {
    return Container(
      height: ScreenUtil().setHeight(360),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendGoodsData.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          _title('商品推荐'),
          _crossList(),
        ],
      ),
    );
  }
}

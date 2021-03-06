/// 首页页面
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  String textContent = 'welcome welcome welcome!';
  int page = 1;
  List<Map> hotGoodsAllData = [];
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _continueGetHotGoodsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formData = {'lon':'115.02932','lat':'35.76189'};
    return Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          future: request('homePageContext', requestData:formData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //json总数据的获取
              var data = json.decode(snapshot.data.toString());
              List<Map> swiperData =(data['data']['slides'] as List).cast(); //轮播图数据解析
              List<Map> homeNavigationListData =(data['data']['category'] as List).cast();  //中上部导航数据解析
              Map adData = data['data']['advertesPicture']; //中部广告控件数据解析
              Map leaderPhoneNumberData = data['data']['shopInfo']; //店长电话数据解析
              List<Map> recommendGoodsData =(data['data']['recommend'] as List).cast(); //推荐商品数据解析
              //楼层标题数据解析
              Map floor1TitleData = data['data']['floor1Pic'];
              Map floor2TitleData = data['data']['floor2Pic'];
              Map floor3TitleData = data['data']['floor3Pic'];
              //楼层内容数据解析
              List<Map> floor1ContentData =(data['data']['floor1'] as List).cast();
              List<Map> floor2ContentData =(data['data']['floor2'] as List).cast();
              List<Map> floor3ContentData =(data['data']['floor3'] as List).cast();


              //界面控件安放
              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key:_footerKey,
                  bgColor:Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  loadText: '上拉加载...',
                  loadingText:'请稍后',
                  noMoreText: '加载成功',
                  moreInfo: '今天又是充满希望的一天',
                  loadReadyText:'松开加载更多内容....'
                ),
                child: ListView(
                  children: <Widget>[
                    HomeTopSwiper(homeTopSwiperImgDataList: swiperData,),
                    HomeNavigation(homeNavigationListData: homeNavigationListData,),
                    HomeMiddleAd( adData: adData,),
                    PlayLeaderPhone(leaderPhoneData: leaderPhoneNumberData,),
                    RecommendGoods(recommendGoodsData: recommendGoodsData,),
                    FloorTitle(floorTitleData: floor1TitleData,),
                    FloorContent(floorContentData: floor1ContentData,),
                    FloorTitle(floorTitleData: floor2TitleData,),
                    FloorContent(floorContentData: floor2ContentData,),
                    FloorTitle(floorTitleData: floor3TitleData,),
                    FloorContent(floorContentData: floor3ContentData,),
                    _hotGoodsAreaBuild(),
                  ],
                ),
                loadMore: (){
                  print('开始加载更多。。。。。');
                  _continueGetHotGoodsData();
                },
              );
            } else {
              return Center(
                child: Text("正在加载..."),
              );
            }
          },
        ));
  }

  //火爆专区数据获取
  void _continueGetHotGoodsData() async{
    var pageData = {'page': page};
    await request('homePageBelowContent', requestData:pageData).then((val){
      var data = json.decode(val.toString());
      List<Map> hotGoodsData = (data['data'] as List).cast();
      setState(() {
        hotGoodsAllData.addAll(hotGoodsData);
        page++;
      });
    });
  }

  //火爆专区标题
  Widget _hotGoodsAreaTitle(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      child: Text("火爆专区",style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(28.0),fontWeight: FontWeight.bold),),
    );
  }

  //火爆专区流式布局
  Widget _hotGoodsArea(){
    if (hotGoodsAllData.length != 0) {
      List <Widget> goodsItemList = hotGoodsAllData.map((val){
        return InkWell(
          onTap: (){print("点击了火爆专区的商品");},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26), ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[
                    Text("￥${val['mallPrice']}"),
                    Text(
                      "￥${val['price']}",
                      style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: goodsItemList,
      );
    } else {
      return Text("无数据 ");
    }
  }

  //火爆专区组合
  Widget _hotGoodsAreaBuild() {
    return Container(
       child: Column(
         children: <Widget>[
           _hotGoodsAreaTitle(),
           _hotGoodsArea(),
         ],
       ),
    );
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

///控件
///楼层标题控件
class FloorTitle extends StatelessWidget {
  final Map floorTitleData;
  const FloorTitle({Key key, this.floorTitleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Image.network(floorTitleData['PICTURE_ADDRESS']),
    );
  }
}

///控件
///楼层内容控件
class FloorContent extends StatelessWidget {
  final List floorContentData;
  const FloorContent({Key key, this.floorContentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _topRow(),
          _bottomRow(),
        ],
      ),
    );
  }

  //每项内容
  Widget _goodsItem(Map goodsData){
    return InkWell(
      onTap: (){print("点击了楼层商品");},
      child: Container(
        width: ScreenUtil().setWidth(375),
        child: Image.network(goodsData['image']),
      ),
    );
  }

  //上部行布局1+2
  Widget _topRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorContentData[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorContentData[1]),
            _goodsItem(floorContentData[2]),
          ],
        )
      ],
    );
  }

  //下部行布局1+1
  Widget _bottomRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorContentData[3]),
        _goodsItem(floorContentData[4]),
      ],
    );
  }
}

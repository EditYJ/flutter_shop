///接口主地址
const serviceUrl = 'http://v.jspang.com:8088/baixing/';

///详细接口地址
const servicePath = {
  'homePageContext': serviceUrl + 'wxmini/homePageContent', //主页，商家页面信息
  'homePageBelowContent': serviceUrl+'wxmini/homePageBelowConten', //商城首页热卖商品拉取
  'getCategory': serviceUrl+'wxmini/getCategory', //商品类别信息
};
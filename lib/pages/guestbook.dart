import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:common_utils/common_utils.dart';

// 主页面
class Guestbook extends StatefulWidget {
  _GuestbookState createState() => _GuestbookState();
}

class _GuestbookState extends State<Guestbook> {
  ScrollController _scrollController = ScrollController();
  bool isFetching = false;
  bool hasMore = true;
  int page = 0;
  List list = new List();
  Map pagination= new Map();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore && !isFetching) {
        fetchData();
      }
    });
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      page += 1;
      isFetching = true;
    });
    getGuestbooks(page)
      .then((response) {
        setState(() {
          isFetching = false;
          pagination = response['result']['pagination'];
          list.addAll(response['result']['list']);
          hasMore = response['result']['pagination']['pageSize'] * response['result']['pagination']['currentPage'] < response['result']['pagination']['total'];
        });
      });
  }

  Future getGuestbooks(page) async {
    try {
      var data = { 'pageSize': 50, 'page': page};
      Response response = await Dio().get('https://www.sweetsmartstrongshen.cc/api/guestbook/list', queryParameters: data);
      return response.data;
    } catch(e) {
      return print(e);
    }
  }

  Future _onRefresh() async {
    setState(() {
      page = 0;
      isFetching = false;
      hasMore = true;
      list = new List();
      pagination= new Map();
    });
    fetchData();
    return;
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomWidget;
    if (hasMore && !isFetching) {
      bottomWidget = Text('加载更多');
    } else if (!hasMore && !isFetching) {
      bottomWidget = Text('没有更多');
    } else if (isFetching) {
      bottomWidget = CupertinoActivityIndicator();
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        title: Text('香饽饽博客', style: TextStyle(
          color: Color.fromRGBO(34, 34, 34, 1.0)
        ),),
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              Solgan(),
              BtnNewMessage(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(10)),
                child: Text('已有${pagination['total'] != null ? pagination['total'] : 0}条留言', style: TextStyle(color: Color.fromRGBO(34, 34, 34, 0.65), fontSize: 14.0)),
              ),
              Column(
                children: list.map((item) {
                  return GuestbookItem(item['user']['portrait'], item['user']['nickname'] == null ? item['user']['mail'] : item['user']['nickname'], item['message'], item['create_at']);
                }).toList(),
              ),
              Container(
                height: ScreenUtil().setWidth(40),
                margin:EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(10)),
                alignment: Alignment.center,
                child: bottomWidget
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 留言模块
class GuestbookItem extends StatefulWidget {
  final String portrait;
  final String nickname;
  final String message;
  final String createAt;

  GuestbookItem(this.portrait, this.nickname, this.message, this.createAt);
  _GuestbookItemState createState() => _GuestbookItemState();
}

class _GuestbookItemState extends State<GuestbookItem> {
  @override
  Widget build(BuildContext context) {
    String formatedCreateAt = DateUtil.getDateStrByDateTime(DateTime.parse(widget.createAt).toLocal(), format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);

    return Container(
      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), ScreenUtil().setWidth(10)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      width: ScreenUtil().setWidth(355),
      color: Color.fromRGBO(255, 255, 255, 0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(12), 0),
                child: ClipOval(
                  child: Image.network(widget.portrait == null ? 'https://www.sweetsmartstrongshen.cc/_nuxt/img/d5fe5cb.jpg' : widget.portrait, width: ScreenUtil().setWidth(18), height: ScreenUtil().setWidth(18), fit: BoxFit.cover,),
                ),
              ),
              Text(widget.nickname),
            ]
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(12), 0, ScreenUtil().setWidth(12)),
            child: Text(widget.message),
          ),
          Align(
            alignment: FractionalOffset.centerRight,
            child: Text(formatedCreateAt, style: TextStyle(),)
          )
        ],
      ),
    );
  }
}

// slogan
class Solgan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Text('Stay Hungry, Stay Foolish', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.65), fontSize: 20.0)),
      ),
    );
  }
}

// 留言按钮
class BtnNewMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(10)),
      child: RaisedButton(
        color: Colors.pinkAccent,
        child: Text('我要留言', style: TextStyle(color: Colors.white)),
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('提示'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('功能开发中，'),
                      Text('可以先去PC端留言'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    textColor: Color.fromRGBO(34, 34, 34, 1.0),
                    child: Text('知道了'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
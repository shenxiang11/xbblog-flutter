import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:common_utils/common_utils.dart';
import './blog_detail.dart';

class BlogList extends StatefulWidget {
  final category;

  BlogList(this.category);
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  bool isFetching = false;
  bool hasMore = true;
  int page = 0;
  List list = new List();
  Map pagination= new Map();

  @override
  bool get wantKeepAlive => true;

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchData() {
    setState(() {
      page += 1;
      isFetching = true;
    });
    getArticles(page)
      .then((response) {
        setState(() {
          isFetching = false;
          pagination = response['result']['pagination'];
          list.addAll(response['result']['list']);
          hasMore = response['result']['pagination']['pageSize'] * response['result']['pagination']['currentPage'] < response['result']['pagination']['total'];
        });
      });
  }

  Future getArticles(page) async {
    try {
      var data = { 'pageSize': 10, 'category': widget.category, 'currentPage': page };
      Response response = await Dio().get('https://m.sweetsmartstrongshen.cc/api/article/list/client', queryParameters: data);
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

    return RefreshIndicator(
      onRefresh: () {
        return _onRefresh();
      },
      child: SingleChildScrollView(
        child:Container(
          margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(10), 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: list.map((item) {
                  return BlogItem(item['_id'], item['title'], item['description'], item['category'], item['create_at'], item['view'].toString());
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
      )
    );
  }
}

class BlogItem extends StatelessWidget {
  final String _id;
  final String title;
  final String description;
  final String category;
  final String createAt;
  final String view;
  
  BlogItem(this._id, this.title, this.description, this.category, this.createAt, this.view);

  @override
  Widget build(BuildContext context) {
    String formatedCreateAt = DateUtil.getDateStrByDateTime(DateTime.parse(createAt).toLocal(), format: DateFormat.YEAR_MONTH_DAY);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => BlogDetail({'_id': _id, 'title':title, 'description': description, 'category': category, 'view': view })
          )
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), ScreenUtil().setWidth(10)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        width: ScreenUtil().setWidth(355),
        color: Color.fromRGBO(255, 255, 255, 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(12)),
              child: Text(title, style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0), fontSize: 16.0, fontWeight: FontWeight.w700),),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setWidth(12)),
              child: Text(description, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.43), fontSize: 14.0, fontWeight: FontWeight.w300),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(6), 0),
                            child: Icon(IconData(0xe607, fontFamily: 'iconfont'), size: 14.0, color: Color.fromRGBO(0, 0, 0, 0.43),),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(12), 0),
                            child: Text(category, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.43), fontSize: 14.0),),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(6), 0),
                            child: Icon(IconData(0xe600, fontFamily: 'iconfont'), size: 14.0, color: Color.fromRGBO(0, 0, 0, 0.43),),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(12), 0),
                            child: Text(view, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.43), fontSize: 14.0),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(formatedCreateAt, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.43), fontSize: 14.0),)
              ],
            ),
          ],
        ),
      )
    );
  }
}
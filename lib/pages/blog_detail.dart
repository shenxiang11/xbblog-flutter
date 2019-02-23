import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BlogDetail extends StatefulWidget {
  final Map article;
  BlogDetail(this.article);
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  Map _article;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    getArticleDetail(widget.article['_id'])
      .then((response) {
        setState(() {
          _article = response['result'];        
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    Map _r = _article == null ? widget.article : _article;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
        title: Text(_r['title'], style: TextStyle(
          color: Color.fromRGBO(34, 34, 34, 1.0)
        ),),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(12), 0, ScreenUtil().setWidth(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(6), 0),
                      child: Icon(IconData(0xe607, fontFamily: 'iconfont'), size: 14.0, color: Color.fromRGBO(34, 34, 34, 1),),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(12), 0),
                      child: Text(_r['category'], style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1), fontSize: 14.0),),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(12), 0, 0, 0),
                      child: Text("${_r['view']}次阅读", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.65), fontSize: 14.0),),
                    )
                  ],
                ),
              ),
              Container(
                child: Text(_r['description'], style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1.0), fontSize: 16.0),),
              ),
              MarkdownBody(data: _r['content'] == null ? '' : _r['content'])
            ],
          ),
        )
      ),
    );
  }

  Future getArticleDetail(_id) async {
    try {
      Response response = await Dio().get('https://m.sweetsmartstrongshen.cc/api/article/client/$_id');
      return response.data;
    } catch(e) {
      return print(e);
    }
  }
}
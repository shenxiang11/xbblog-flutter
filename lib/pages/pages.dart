import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './blog_index.dart';
import './guestbook.dart';

class Pages extends StatefulWidget {
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(
      icon: Icon(IconData(0xe6b9, fontFamily: 'iconfont')),
      title: Text('博客')
    ),
    BottomNavigationBarItem(
      icon: Icon(IconData(0xe637, fontFamily: 'iconfont')),
      title: Text('留言板'),
    )
  ];

  final List<Widget> tabScreens = [
    BlogIndex(),
    Guestbook()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color.fromRGBO(34, 34, 34, 1.0),
        type: BottomNavigationBarType.fixed,
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: tabScreens[_currentIndex],
    );
  }
}
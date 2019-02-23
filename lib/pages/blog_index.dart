import 'package:flutter/material.dart';
import './blog_list.dart';

class BlogIndex extends StatefulWidget {
  _BlogIndexState createState() => _BlogIndexState();
}

class _BlogIndexState extends State<BlogIndex> with SingleTickerProviderStateMixin {
  TabController _controller;
  Map<String,Widget> categoryPage = {
    'code': BlogList('code'),
    'think': BlogList('think'),
    'fitness': BlogList('fitness')
  };
  String category = 'code';

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
          title: Text('香饽饽博客', style: TextStyle(
            color: Color.fromRGBO(34, 34, 34, 1.0)
          ),),
          elevation: 0.0,
          bottom: TabBar(
            controller: _controller,
            labelColor: Color.fromRGBO(34, 34, 34, 1.0),
            indicatorColor: Color.fromRGBO(34, 34, 34, 1.0),
            tabs: choices.map((Choice choice) {
              return new Tab(
                text: choice.title
              );
            }).toList(),
            onTap: (index) {
              setState(() {
                category = choices[index].key;
              });
            },
          ),
        ),
        backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            BlogList('code'),
            BlogList('think'),
            BlogList('fitness')
          ],
        )
      ),
    );
  }
}

class Choice {
  const Choice({ this.title, this.key });
  final String title;
  final String key;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '代码', key: 'code'),
  const Choice(title: '思考', key: 'think'),
  const Choice(title: '健身', key: 'fitness')
];
import 'package:flutter/material.dart';
import './pages.dart';

class LaunchScreen extends StatefulWidget {
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation = Tween(begin: 0.3, end: 1.0).animate(_controller);
  
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        new Future.delayed(Duration(milliseconds: 2000), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Pages()),
            (route) => route == null
          );
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Image.asset('assets/images/launch_screen.jpg', 
        scale: 2.0,
        fit:BoxFit.cover
      ),
    );
  }
}
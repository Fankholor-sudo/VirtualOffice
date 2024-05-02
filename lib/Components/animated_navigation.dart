import 'package:flutter/cupertino.dart';

class AnimatedNavigation extends PageRouteBuilder{
  final Widget page;
  AnimatedNavigation({required this.page}):super(
    transitionDuration: Duration(milliseconds: 50),
    transitionsBuilder: (context, animation, animationTime, child){
      Animation<Offset> offsetAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
      return SlideTransition(position: offsetAnimation, child: child);
    },
    pageBuilder: (context, animation, animationTime){
      return page;
    }
  );
}
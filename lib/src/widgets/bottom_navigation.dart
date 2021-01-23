import 'package:flutter/material.dart';
class BottomNavigation extends StatefulWidget{
  @override
  __BottomNavigationState createState() => __BottomNavigationState();
}

class __BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index){
        setState(() {
          _currentIndex=index;
        });
      },
      items:[
        BottomNavigationBarItem(icon: Icon(Icons.home),label:'Home',),
        BottomNavigationBarItem(icon: Icon(Icons.person),label:'Profile',),
        BottomNavigationBarItem(icon: Icon(Icons.settings),label:'Settings',),
      ],
    );
  }
}
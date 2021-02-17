import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/user_bloc/state.dart';


class BottomNavigation extends StatelessWidget {
  final Function(int) onChange;
   final UserState userState;
   final int currentIndex;
    BottomNavigation({@required this.onChange,@required this.userState,@required this.currentIndex});

  _handleTap(int index,BuildContext context){
    if(_canAccess()){
      onChange(index);
    }else{
      if(index!=0){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('You need to log in and to be member of this meetup!'),duration: Duration(seconds: 1),));
      }
    }

  }

  bool _canAccess(){
    return userState is UserIsMember || userState is UserIsMeetupOwner;
  }

  Color _renderColor(){
    return (userState is UserIsMember || userState is UserIsMeetupOwner)?null:Colors.black12;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i)=>_handleTap(i,context),
      items:[
        BottomNavigationBarItem(icon: Icon(Icons.home,),label:'Detail',),
        BottomNavigationBarItem(icon: Icon(Icons.note,color: _renderColor()),label:'Threads',),
        BottomNavigationBarItem(icon: Icon(Icons.people,color: _renderColor()),label:'People',),
      ],
    );
  }
}
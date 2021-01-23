import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget{
  final String _title;
  CounterHomeScreen({String title}) : _title = title;

  @override
  CounterHomeScreenState createState()=>CounterHomeScreenState();

}

class CounterHomeScreenState extends State<CounterHomeScreen>{

  int _counter=0;


  void _increment(){
    setState(() {
      _counter++;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to ${widget._title}, lets increment numbers!',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              'Click Counter: $_counter',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 30.0),
            ),
            RaisedButton(child: Text('Go To Detail'),
            onPressed: ()=>Navigator.pushNamed(context, '/meetupDetail'),),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed:_increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          widget._title,
        ),
      ),
    );
  }
}


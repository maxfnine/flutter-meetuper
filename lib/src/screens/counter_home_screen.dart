import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;

  CounterHomeScreen({String title}) : _title = title;

  @override
  CounterHomeScreenState createState() => CounterHomeScreenState();
}

class CounterHomeScreenState extends State<CounterHomeScreen> {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  final StreamController<int> _counterController =
  StreamController<int>.broadcast();

  int _counter = 0;

  void initState() {
    super.initState();
    _streamController.stream
        .listen((number) {
      _counter=_counter+number;
      _counterController.sink.add(_counter);
    });
  }
@override
void dispose(){
    super.dispose();
    _streamController.close();
    _counterController.close();
}
  void _increment() {
    // setState(() {
    //   _counter++;
    // });
    _streamController.sink.add(10);
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
            StreamBuilder(stream: _counterController.stream,
            initialData: _counter,
            builder: (BuildContext context,AsyncSnapshot<int> snapshot){
              if(snapshot.hasData) {
                return Text(
                  'Click Counter: ${snapshot.data}',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 30.0),
                );
              }else{
                return Text(
                  'Click is sad :(',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 30.0),
                );
              }
            },),
            RaisedButton(
              child:  StreamBuilder(stream: _counterController.stream,
                initialData: _counter,
                builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                  if(snapshot.hasData) {
                    return Text(
                      'Counter - ${snapshot.data}',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontSize: 30.0),
                    );
                  }else{
                    return Text(
                      'Click is sad :(',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontSize: 30.0),
                    );
                  }
                },),
              onPressed: () => Navigator.pushNamed(context, '/meetupDetail'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
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

import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/bloc_provider.dart';
import '../widgets/bottom_navigation.dart';
import '../blocs/counter_bloc.dart';

class CounterHomeScreen extends StatefulWidget {
  final String _title;


  CounterHomeScreen({String title}) : _title = title;

  @override
  CounterHomeScreenState createState() => CounterHomeScreenState();
}

class CounterHomeScreenState extends State<CounterHomeScreen> {
  CounterBloc counterBloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    counterBloc=BlocProvider.of<CounterBloc>(context);
  }



  void _increment() {
    counterBloc.increment(15);
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
            StreamBuilder(
              stream: counterBloc.counterStream,
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
              child:  StreamBuilder(
                stream: counterBloc.counterStream,

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

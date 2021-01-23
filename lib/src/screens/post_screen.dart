import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../widgets/bottom_navigation.dart';

class PostScreen extends StatefulWidget{
  @override
  _PostScreenState createState()=>_PostScreenState();

}

class _PostScreenState extends State<PostScreen>{
  List<dynamic> _posts=[];
  @override
  void initState(){
    super.initState();
    get('https://jsonplaceholder.typicode.com/posts').then((response)
    {
      final  posts = json.decode(response.body);
      print(posts);
      setState(() {
        _posts=posts;
      });
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
              'Welcome in Posts Screen',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>{},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Posts',
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/meetup_detail_screen.dart';
import 'src/screens/post_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = 'Meetuper App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostScreen(),
      routes: {
        MeetupDetailScreen.route:(context)=>MeetupDetailScreen(),
      },
    );
  }
}



import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/meetup_detail_screen.dart';
import '../models/meetup.dart';
import '../services/meetup_api_service.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static const String route = '/home';
  final MeetupApiService _meetupApiService = MeetupApiService();

  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> _meetups = [];

  @override
  void initState() {
    super.initState();
    _fetchMeetups();
  }

  _fetchMeetups() async {
    List<Meetup> meetups = await widget._meetupApiService.fetchMeetups();
    setState(() {
      print(meetups);
      _meetups = meetups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          _MeetupTitle(),
          _MeetupList(
            meetups: _meetups,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Text(
        'Featured Meetup',
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  final Meetup meetup;

  _MeetupCard(this.meetup);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(meetup.image),
          ),
          title: Text(meetup.title),
          subtitle: Text(meetup.description),
        ),
        ButtonTheme.bar(
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MeetupDetailScreen.route,
                    arguments: MeetupDetailArguments(id: meetup.id),
                  );
                },
                child: Text('Visit Meetup'),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Favorite'),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class _MeetupList extends StatelessWidget {
  final List<Meetup> meetups;

  _MeetupList({@required this.meetups});

  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: meetups.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;

        return _MeetupCard(meetups[index]);
      },
    ));
  }
}
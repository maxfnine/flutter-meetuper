import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/screens/login_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_detail_screen.dart';
import '../models/meetup.dart';
import '../blocs/bloc_provider.dart';
import '../services/auth_api_service.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static const String route = '/home';


  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {

  void didChangeDependencies(){
    super.didChangeDependencies();
    final MeetupBloc meetupBloc = BlocProvider.of<MeetupBloc>(context);
    meetupBloc.fetchMeetups();
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
          _MeetupList(),
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
  final AuthApiService _authApiService = AuthApiService();

  Widget _buildUserWelcome(){
    return FutureBuilder<bool>(future:_authApiService.isAuthenticated(),builder: (BuildContext context,AsyncSnapshot<bool> snapshot){
      if(snapshot.hasData && snapshot.data){
        final user  =_authApiService.authUser;
        return Container(
          margin: EdgeInsets.only(
            top: 10.0,
          ),
          child: Row(
            children: <Widget>[
              user.avatar != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              )
                  : Container(
                width: 0.0,
                height: 0.0,
              ),
              Text('Welcome ${user.username}'),
              Spacer(),
              GestureDetector(
                child: Text(
                  'Logout',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: (){
                  _authApiService.logout().then((value) => Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false),);
                  },
              )
            ],
          ),
        );
      }else{
        return Container(
          width: 0.0,
          height: 0.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Featured Meetups',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          _buildUserWelcome()
        ],
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
  _MeetupList();

  Widget build(BuildContext context) {
    return Expanded(
      child:StreamBuilder<List<Meetup>>(
        stream: BlocProvider.of<MeetupBloc>(context).meetups,
        initialData: [],
        builder: (BuildContext context,AsyncSnapshot<List<Meetup>> snapshot){
          final meetups = snapshot.data;
          return ListView.builder(
            itemCount: meetups.length * 2,
            itemBuilder: (BuildContext context, int i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;

              return _MeetupCard(meetups[index]);
            },
          );
        },
      )
       );
  }
}

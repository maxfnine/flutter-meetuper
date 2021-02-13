import 'dart:async';
import '../models/user.dart';
import 'package:flutter_meetuper/src/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/src/models/meetup.dart';
import 'package:flutter_meetuper/src/services/auth_api_service.dart';
import 'package:flutter_meetuper/src/services/meetup_api_service.dart';

class MeetupBloc implements BlocBase {
  final MeetupApiService _api = MeetupApiService();
  final AuthApiService _auth=AuthApiService();
  final StreamController<List<Meetup>> _meetupController =
      StreamController.broadcast();
  final StreamController<Meetup> _meetupDetailController =
  StreamController.broadcast();

  Stream<List<Meetup>> get meetups => _meetupController.stream;
  StreamSink<List<Meetup>> get _inMeetups => _meetupController.sink;

  Stream<Meetup> get meetup => _meetupDetailController.stream;
  StreamSink<Meetup> get _inMeetup => _meetupDetailController.sink;

  void fetchMeetups() async {
    final meetups = await _api.fetchMeetups();
    _inMeetups.add(meetups);
  }

  void fetchMeetup(String meetupId) async{
    final meetup = await _api.fetchMeetupById(meetupId);
    print(meetup);
    print(meetup);
    _inMeetup.add(meetup);
  }

  void joinMeetup(Meetup meetup){
    _api.joinMeetup(meetup.id)
    .then((_){
      User user=_auth.authUser;
      user.joinedMeetups.add(meetup.id);
      meetup.joinedPeople.add(user);
      meetup.joinedPeopleCount++;
      _inMeetup.add(meetup);
    })
    .catchError((error)=>print(error));
  }

  void leaveMeetup(Meetup meetup){
    _api.leaveMeetup(meetup.id)
        .then((_){
      User user=_auth.authUser;
      user.joinedMeetups.removeWhere((jMeetup)=>meetup.id==jMeetup);
      meetup.joinedPeople.removeWhere((jUser)=>jUser.id==user.id);
      meetup.joinedPeopleCount--;
      _inMeetup.add(meetup);
    })
        .catchError((error)=>print(error));
  }

  @override
  void dispose() {
    _meetupController.close();
    _meetupDetailController.close();
  }
}

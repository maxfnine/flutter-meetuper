import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import '../models/meetup.dart';
class MeetupApiService{
  static final MeetupApiService _singleton = MeetupApiService._internal();
  final String url=Platform.isIOS?'http://localhost:3001/api/v1':'http://10.100.102.21:3001/api/v1';

  factory MeetupApiService(){
    return _singleton;
  }

  MeetupApiService._internal();

  Future<List<Meetup>> fetchMeetups() async{
    final response = await http.get('$url/meetups');
    final List meetups = json.decode(response.body);
    return meetups.map((meetup) =>Meetup.fromJSON(meetup)).toList();
  }

  Future<Meetup> fetchMeetupById(String meetupId) async{
    final response = await http.get('$url/meetups/$meetupId');
    return Meetup.fromJSON(json.decode(response.body));
  }
}
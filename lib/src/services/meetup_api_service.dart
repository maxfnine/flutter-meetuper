import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import '../models/meetup.dart';
import '../models/category.dart';
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

  Future<bool> joinMeetup(String meetupId) async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      await http.post('$url/meetups/$meetupId/join',
          headers: {'Authorization': 'Bearer $token'});
      return true;
    }catch(e){
      throw Exception('Cannot join meetup!');
    }
  }

  Future<bool> leaveMeetup(String meetupId) async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token');
      await http.post('$url/meetups/$meetupId/leave',
          headers: {'Authorization': 'Bearer $token'});
      return true;
    }catch(e){
      throw Exception('Cannot leave meetup!');
    }
  }

  Future<List<Category>> fetchCategories() async{
    final response=await http.get('$url/categories');
    final List decodedBody = json.decode(response.body);
    return decodedBody.map((category) =>Category.fromJSON(category)).toList();
  }
}
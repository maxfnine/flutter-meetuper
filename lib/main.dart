import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/screens/login_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_detail_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';

void main() => runApp(MeetuperApp());

class MeetuperApp extends StatelessWidget {
  final String appTitle = 'Meetuper App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        MeetupDetailScreen.route:(context)=>MeetupDetailScreen(),
        MeetupHomeScreen.route:(context)=>MeetupHomeScreen(),
        LoginScreen.route:(context)=>LoginScreen(),
        RegisterScreen.route:(context)=>RegisterScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailScreen.route) {
          final MeetupDetailArguments arguments = settings.arguments;
          print(arguments);
          return MaterialPageRoute(
              builder: (context) => MeetupDetailScreen(meetupId: arguments.id));
        } else if (settings.name == LoginScreen.route) {
          return MaterialPageRoute(builder: (context) => LoginScreen());
        } else if (settings.name == RegisterScreen.route) {
          return MaterialPageRoute(builder: (context) => RegisterScreen());
        } else {
          return MaterialPageRoute(builder: (context) => MeetupHomeScreen());
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/counter_bloc.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/models/arguments.dart';
import 'package:flutter_meetuper/src/screens/counter_home_screen.dart';
import 'package:flutter_meetuper/src/screens/login_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_detail_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';
import './src/blocs/bloc_provider.dart';

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
          // BlocProvider<CounterBloc>(
          //   bloc: CounterBloc(),
          //   child: CounterHomeScreen(title: appTitle),
          // ),

      routes: {
        MeetupHomeScreen.route: (context) => BlocProvider<MeetupBloc>(bloc:MeetupBloc(),child:MeetupHomeScreen(),),
        RegisterScreen.route: (context) => RegisterScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailScreen.route) {
          final MeetupDetailArguments arguments = settings.arguments;
          print(arguments);
          return MaterialPageRoute(
              builder: (context) => BlocProvider<MeetupBloc>(
                  bloc: MeetupBloc(),
                  child: MeetupDetailScreen(meetupId: arguments.id)
              ));
        } else if (settings.name == LoginScreen.route) {
          final LoginScreenArguments arguments = settings.arguments;
          return MaterialPageRoute(
              builder: (context) => LoginScreen(message: arguments?.message));
        } else if (settings.name == RegisterScreen.route) {
          return MaterialPageRoute(builder: (context) => RegisterScreen());
        } else {
          return MaterialPageRoute(builder: (context) => MeetupHomeScreen());
        }
      },
    );
  }
}

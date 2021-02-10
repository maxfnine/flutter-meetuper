import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_meetuper/src/blocs/counter_bloc.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/models/arguments.dart';
import 'package:flutter_meetuper/src/screens/counter_home_screen.dart';
import 'package:flutter_meetuper/src/screens/login_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_detail_screen.dart';
import 'package:flutter_meetuper/src/screens/meetup_home_screen.dart';
import 'package:flutter_meetuper/src/screens/register_screen.dart';
import 'package:flutter_meetuper/src/services/auth_api_service.dart';
import './src/blocs/bloc_provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      child: MeetuperApp(),
      bloc: AuthBloc(
        auth: AuthApiService(),
      ),
    );
  }
}

class MeetuperApp extends StatefulWidget {
  @override
  _MeetuperAppState createState() => _MeetuperAppState();
}

class _MeetuperAppState extends State<MeetuperApp> {
  final String appTitle = 'Meetuper App';
  AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:StreamBuilder<AuthenticationState>(
        stream: authBloc.authState,
        initialData: AuthenticationUnauthenticated(),
        builder: (BuildContext context,AsyncSnapshot<AuthenticationState> snapshot){
          final AuthenticationState state = snapshot.data;

          if( state is AuthenticationUninitialized){
            return SplashScreen();
          }

          if(state is AuthenticationAuthenticated){
            return BlocProvider<MeetupBloc>(child: MeetupHomeScreen(), bloc: MeetupBloc());
          }

          if(state is AuthenticationUnauthenticated){
            final LoginScreenArguments arguments = !state.logout?ModalRoute.of(context).settings.arguments:null;
            return LoginScreen(message: arguments?.message);
          }

          if(state is AuthenticationLoading){
            return LoadingScreen();
          }
        },
      ),

      // BlocProvider<CounterBloc>(
      //   bloc: CounterBloc(),
      //   child: CounterHomeScreen(title: appTitle),
      // ),

      routes: {
        MeetupHomeScreen.route: (context) => BlocProvider<MeetupBloc>(
              bloc: MeetupBloc(),
              child: MeetupHomeScreen(),
            ),
        RegisterScreen.route: (context) => RegisterScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == MeetupDetailScreen.route) {
          final MeetupDetailArguments arguments = settings.arguments;
          print(arguments);
          return MaterialPageRoute(
              builder: (context) => BlocProvider<MeetupBloc>(
                  bloc: MeetupBloc(),
                  child: MeetupDetailScreen(meetupId: arguments.id)));
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

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


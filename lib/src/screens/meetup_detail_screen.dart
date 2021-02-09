import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/bloc_provider.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/services/meetup_api_service.dart';
import '../widgets/bottom_navigation.dart';
import '../models/meetup.dart';

class MeetupDetailScreen extends StatefulWidget {
  static const String route = '/meetupDetail';
  final String meetupId;
  final MeetupApiService _meetupApiService = MeetupApiService();

  MeetupDetailScreen({this.meetupId});

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {

  void didChangeDependencies(){
    super.didChangeDependencies();
    final MeetupBloc meetupBloc = BlocProvider.of<MeetupBloc>(context);
    meetupBloc.fetchMeetup(widget.meetupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetup Details'),
      ),
      body:
      StreamBuilder(
        stream: BlocProvider.of<MeetupBloc>(context).meetup,

        builder: (BuildContext context,AsyncSnapshot<Meetup> snapshot){
          if(snapshot.hasData){
            final Meetup meetup=snapshot.data;
            return ListView(children: [
              HeaderSection(
                meetup,
              ),
              TitleSection(
                meetup,
              ),
              AdditionalInfoSectionSection(
                meetup,
              ),
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer purus leo, vulputate pellentesque augue eleifend, semper porta orci. Quisque vestibulum vitae nisl in maximus. Donec varius rutrum risus. Mauris quis lectus suscipit, viverra urna ut, euismod nunc. Praesent magna mauris, sagittis sed dolor vel, accumsan accumsan purus. Vivamus molestie tempus sem, eu condimentum lorem scelerisque sed. Phasellus metus enim, tristique vitae tempor semper, lacinia ac libero. Vivamus congue ex id turpis fringilla fermentum. In tristique vehicula aliquet.'),
                ),
              ),
            ]);
          }else{
          return Container(
          width: 0.0,
          height: 0.0,
          );
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class AdditionalInfoSectionSection extends StatelessWidget {
  final Meetup meetup;

  const AdditionalInfoSectionSection(this.meetup);

  Widget _buildColumn(String label, String text, Color color) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 13.0, fontWeight: FontWeight.w400, color: color),
        ),
        Text(
          _capitalize(text),
          style: TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.w500, color: color),
        ),
      ],
    );
  }

  _capitalize(String word) => word != null && word.isNotEmpty
      ? word[0].toUpperCase() + word.substring(1)
      : '';

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildColumn('CATEGORY', meetup.category.name, color),
        _buildColumn('FROM', meetup.timeFrom, color),
        _buildColumn('TO', meetup.timeTo, color),
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  final Meetup meetup;

  const TitleSection(this.meetup);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  meetup.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  meetup.shortInfo,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(
            Icons.people,
            color: color,
          ),
          Text('${meetup.joinedPeopleCount} People')
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Meetup meetup;

  const HeaderSection(this.meetup);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Image.network(
          meetup.image,
          width: width,
          height: 240.0,
          fit: BoxFit.cover,
        ),
        Container(
          width: 640.0,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    'https://ra.ac.ae/wp-content/uploads/2017/02/user-icon-placeholder.png'),
              ),
              title: Text(
                meetup.title,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              subtitle: Text(
                meetup.shortInfo,
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}

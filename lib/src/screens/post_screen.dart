import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../models/post.dart';
import '../services/post_api_provider.dart';
import 'package:faker/faker.dart';

class PostScreen extends StatefulWidget{
  final PostApiProvider _postApiProvider = PostApiProvider();
  @override
  _PostScreenState createState()=>_PostScreenState();

}

class _PostScreenState extends State<PostScreen>{
  List<Post> _posts=[];

  @override
  void initState(){
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async{
    List<Post> posts = await widget._postApiProvider.fetchPosts();
    setState(() {
      print(posts);
      _posts=posts;
    });
  }

  _addPost(){
    final id=faker.randomGenerator.integer(9999);
    final title=faker.food.dish();
    final body=faker.food.cuisine();
    final newPost = Post(id: id,title: title,body: body);
    setState(() {
      _posts.add(newPost);
    });
  }


  @override
  Widget build(BuildContext context) {
    return _PostList(posts: _posts,createPost: _addPost,);
  }
}


class _PostList extends StatelessWidget {
  final List<dynamic> _posts;
  final Function() createPost;

  _PostList({@required List<Post> posts,@required Function() createPost}):_posts=posts,this.createPost=createPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount: _posts.length*2,
          itemBuilder: (BuildContext context,int i){

            if(i.isOdd){
              return Divider();
            }
            final index=i~/2;
            return new ListTile(title: Text(_posts[index].title),subtitle: Text(_posts[index].body),);
          }),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed:createPost,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Posts',
        ),
      ),
    );
  }
}

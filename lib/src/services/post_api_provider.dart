import 'package:http/http.dart';
import 'dart:convert';
import '../models/post.dart';
class PostApiProvider{
  static final PostApiProvider _postApiProvider=PostApiProvider._internal();
  PostApiProvider._internal();
  factory PostApiProvider()=>_postApiProvider;

  Future<List<Post>> fetchPosts() async {
    final response = await get('https://jsonplaceholder.typicode.com/posts');
    final List<dynamic> parsedPosts = json.decode(response.body);
    return parsedPosts.map((post)=>Post.fromJSON(post)).take(2).toList();
  }
}
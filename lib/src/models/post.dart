class Post {
  final String title;
  final String body;
  final int id;

  Post({this.title, this.body, this.id});

  Post.fromJSON(Map<String, dynamic> parsedPost)
      : this.title = parsedPost['title'],
        this.body = parsedPost['body'],
        this.id = parsedPost['id'];
}

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  String avatar;
  String info;
  List<String> joinedMeetups = [];

  User.fromJSON(Map<String, dynamic> parsedJson)
      : this.id = parsedJson['_id'],
        this.name = parsedJson['name'],
        this.username = parsedJson['username'],
        this.email = parsedJson['email'],
        this.info = parsedJson['info'] ?? '',
        this.avatar = parsedJson['avatar'] ?? '',
        this.joinedMeetups = parsedJson['joinedMeetups']?.cast<String>() ?? [];

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username, email: $email, avatar: $avatar, info: $info, joinedMeetups: $joinedMeetups}';
  }
}
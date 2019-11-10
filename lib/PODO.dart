class Choice {
  final int id;
  final String name;
  final String description;
  final int numberOfVotes;
  Choice({this.id, this.name, this.description, this.numberOfVotes});
  factory Choice.fromJson(Map<String, dynamic> parsedJson) {
    return Choice(
        id: parsedJson['id'],
        name: parsedJson['name'],
        description: parsedJson['description'],
        numberOfVotes: 0);
  }
}

class Vote {
  final int id;
  final User member;
  final Choice choice;
  Vote({this.id, this.member, this.choice});
  factory Vote.fromJson(Map<String, dynamic> parsedJson) {
    return Vote(
        choice: Choice.fromJson(parsedJson['choice']),
        id: parsedJson['id'],
        member: User.fromJson(parsedJson['member']));
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String userName;
  User({this.id, this.firstName, this.lastName, this.userName});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['id'],
        firstName: parsedJson['firstName'],
        lastName: parsedJson['lastName'],
        userName: parsedJson['userName']);
  }
}

class Election {
  final int id;
  Election({this.id});
  factory Election.fromJson(Map<String, dynamic> parsedJson) {
    return Election(id: parsedJson['id']);
  }
}

class Group {
  final int id;
  final String name;
  final String location;
  final List<User> members;
  final List<Election> elections;
  final List<Choice> choices;
  Group(
      {this.id,
      this.name,
      this.location,
      this.members,
      this.elections,
      this.choices});
  factory Group.fromJson(Map<String, dynamic> parsedJson) {
    var mlist = parsedJson['members'] as List;
    List<User> members = mlist.map((i) => User.fromJson(i)).toList();
    var elist = parsedJson['elections'] as List;
    List<Election> elections = elist.map((i) => Election.fromJson(i)).toList();
    var clist = parsedJson['lunchLocations'] as List;
    List<Choice> choices = clist.map((i) => Choice.fromJson(i)).toList();
    return Group(
        id: parsedJson['id'],
        name: parsedJson['name'],
        location: parsedJson['groupLocation'],
        members: members,
        elections: elections,
        choices: choices);
  }
}

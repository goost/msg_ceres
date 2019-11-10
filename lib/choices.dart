import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PODO.dart';
import 'RESTClient.dart';

// Create a stateful widget
class ChoicesScreen extends StatefulWidget {
  @override
  ChoicesData createState() => ChoicesData();
}

// Create the state for our stateful widget
class ChoicesData extends State<ChoicesScreen> {
  static const GroupId = 1;
  Election currentElection;
  String groupName;
  List<Choice> choices;
  String newChoiceName = '';
  String newChoiceDescription = '';
  String userName = 'default';
  User currentUser =
      User(firstName: "unset", lastName: "unset", userName: "unset");

  _onVotePressed(int choiceId) {
    return () {
      deleteVoteforChoice(
              currentUser.id, ChoicesData.GroupId, currentElection.id)
          .whenComplete(() => voteForChoice(currentUser.id, ChoicesData.GroupId,
                      currentElection.id, choiceId)
                  .then((vote) {
                print('-----Pressed $choiceId and: $vote');
                _loadItAll();
              }));
    };
  }

  Widget _listBuild(BuildContext context, int index) {
    var localTheme = Theme.of(context);
    return Container(
      child: Center(
          child: Column(
        // Stretch the cards in horizontal axis
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            // margin: EdgeInsets.symmetric(vertical: 5),

            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(choices[index].name,
                          style: localTheme.textTheme.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple)),
                      Row(
                        children: <Widget>[
                          Text('${choices[index].numberOfVotes}',
                              style: localTheme.textTheme.title),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          RaisedButton(
                            child: Text(
                              "Vote",
                              style: localTheme.textTheme.button,
                            ),
                            onPressed: _onVotePressed(choices[index].id),
                          )
                        ],
                      )
                    ],
                  ),
                  Text(choices[index].description,
                      style: localTheme.textTheme.subhead
                          .copyWith(fontStyle: FontStyle.italic)),
                ],
                // added padding
              ),
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context).settings.arguments;
    print("-----Got username: $user");
    this.userName = user.isEmpty ? "default" : user;
    return Scaffold(
      appBar: AppBar(
        //TODO (glost) Read groupname
        title: Text(groupName ?? "${currentUser.userName}, choose your poison"),
      ),
      // Create a Listview and load the data when available
      body: RefreshIndicator(
        child: ListView.builder(
            itemCount: choices == null ? 0 : choices.length,
            itemBuilder: _listBuild),
        onRefresh: () async {
          _loadItAll();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => _addChoiceDialogBuilder(context));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.tealAccent,
      ),
    );
  }

  Widget _addChoiceDialogBuilder(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              "Add new choice",
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            //TODO (glost): TextFieldBuilder is not disposed
            TextField(
                onChanged: (v) => newChoiceName = v,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name')),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            TextField(
                onChanged: (v) => newChoiceDescription = v,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Description')),
            Wrap(
              children: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    newChoiceDescription = "";
                    newChoiceName = "";
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Submit"),
                  onPressed: () {
                    createChoice(
                            1, 1, this.newChoiceName, this.newChoiceDescription)
                        .whenComplete(() {
                      _loadItAll();
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 250)).whenComplete(() async {
      print('Using username ${this.userName}');
      await createUser(this.userName);
      var users = await getAllUsers();
      this.currentUser =
          users.singleWhere((it) => it.userName == this.userName);
      await addUserToGroup(this.currentUser.id, ChoicesData.GroupId);
      _loadItAll();
    });
  }

  void _loadItAll() async {
    print('Using username ${this.userName}');
    await createUser(this.userName);
    var users = await getAllUsers();
    this.currentUser = users.singleWhere((it) => it.userName == this.userName);

    var elections = await getAllElectionsForGroup(ChoicesData.GroupId);
    print('Elections before Sort');
    elections.forEach((it) => print(it.id));
    //Descending
    elections.sort((l, r) => r.id.compareTo(l.id));
    print('Elections after Sort');
    elections.forEach((it) => print(it.id));

    this.currentElection = elections[0];
    var choices = await getAllChoicesForElectionWithVotes(
        ChoicesData.GroupId, this.currentElection.id);
    setState(() {
      this.choices = choices;
    });
  }
}

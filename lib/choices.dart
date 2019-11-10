import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PODO.dart';
import 'RESTClient.dart';

// Create a stateful widget
class ChoicesData extends StatefulWidget {
  @override
  Choices createState() => Choices();
}

// Create the state for our stateful widget
class Choices extends State<ChoicesData> {
  String groupName;
  List<Choice> choices;
  String newChoiceName = '';
  String newChoiceDescription = '';

  _onVotePressed(int choiceId) {
    return () {
      deleteVoteforChoice(1, 1, 1)
          .whenComplete(() => voteForChoice(1, 1, 1, choiceId).then((vote) {
                print('-----Pressed and: $vote');
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
    return Scaffold(
      appBar: AppBar(
        //TODO (glost) Read groupname
        title: Text(groupName ?? "Choose your poison"),
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
    _loadItAll();
  }

  void _loadItAll() {
    //TODO (glost): Hardcoded values, hardcoded pain
    getAllChoicesForElectionWithVotes(1, 1).then((choices) {
      this.setState(() {
        this.choices = choices;
      });
    });
  }
}

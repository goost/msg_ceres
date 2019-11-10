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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(choices[index].name,
                          style: localTheme.textTheme.display1),
                      Row(
                        children: <Widget>[
                          Text('${choices[index].numberOfVotes}',
                              style: localTheme.textTheme.title
                                  .copyWith(fontSize: 42)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          ),
                          RaisedButton(
                            child: Text(
                              "Vote",
                              style: localTheme.textTheme.button
                                  .copyWith(fontSize: 42),
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
        body: ListView.builder(
            itemCount: choices == null ? 0 : choices.length,
            itemBuilder: _listBuild));
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

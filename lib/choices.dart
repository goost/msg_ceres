import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'RESTClient.dart';

// Create a stateful widget
class ChoicesData extends StatefulWidget {
  @override
  Choices createState() => Choices();
}

// Create the state for our stateful widget
class Choices extends State<ChoicesData> {
  String groupName;
  List data;

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
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data[index]['name'],
                      style: localTheme.textTheme.display1),
                  Text(data[index]['description'],
                      style: localTheme.textTheme.subhead
                          .copyWith(fontStyle: FontStyle.italic))
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
            itemCount: data == null ? 0 : data.length,
            itemBuilder: _listBuild));
  }

  @override
  void initState() {
    super.initState();

    getChoicesForElectionInGroup(1, 1).then((jsonChoices) {
      this.setState(() {
        data = jsonChoices;
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'RESTClient.dart';

void main() {
  runApp(MaterialApp(
    home: ChoicesData(),
  ));
}

// Create a stateful widget
class ChoicesData extends StatefulWidget {
  @override
  Choices createState() => Choices();
}

// Create the state for our stateful widget
class Choices extends State<ChoicesData> {
  List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Retrieve JSON Data via HTTP GET"),
      ),
      // Create a Listview and load the data when available
      body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                  child: Column(
                // Stretch the cards in horizontal axis
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                      child: Text(
                        // Read the name field value and set it in the Text widget
                        //data[index]['name'],
                        '${data[index]['firstName']} username is ${data[index]['userName']}',
                        // set some style to text
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.lightBlueAccent),
                      ),
                      // added padding
                      padding: const EdgeInsets.all(15.0),
                    ),
                  )
                ],
              )),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    getAllUsers().then((jsonUsers) {
      this.setState(() {
        data = jsonUsers;
      });
    });
  }
}

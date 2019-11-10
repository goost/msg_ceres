import 'package:flutter/material.dart';
import 'choices.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.teal,
        buttonColor: Colors.amber,
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
    home: WhoAreYouScreen(),
  ));
}

class WhoAreYouScreen extends StatelessWidget {
  String _userName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who are you?'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                onChanged: (v) => _userName = v,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'UserName')),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            RaisedButton(
              child: Text("Log-In"),
              onPressed: () {
                // When the user taps the button, navigate to the specific route
                // and provide the arguments as part of the RouteSettings.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChoicesScreen(),
                    // Pass the arguments as part of the RouteSettings. The
                    // ExtractArgumentScreen reads the arguments from these
                    // settings.
                    settings: RouteSettings(
                      arguments: _userName,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

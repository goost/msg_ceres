/**
 * Provider for RESTful Futures
 */

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String domain =
    "http://msg-lunchserver6.westeurope.azurecontainer.io:8080";

dynamic _parseJSON(String body, reviver(Object key, Object value)) async {
  //TODO (glost): Reviver Function for static typing of response
  var responseConvertedToJson = json.decode(body, reviver: reviver);
  //TODO (glost): setState() Callback as Parameter?
  return responseConvertedToJson;
}

Future<dynamic> getChoicesForElectionInGroup(
    int groupId, int electionid) async {
  var url = "${domain}/groups/${groupId}/elections/${electionid}/choices";
  var response = await http.get(
      // Encode the url
      Uri.encodeFull(url),
      // Only accept JSON response
      headers: {"Accept": "application/json"});

  // Logs the response body to the console
  print("------GetChoicesForElectionInGroup:\n${response.body}");

  return _parseJSON(response.body, null);
}

Future<dynamic> getAllUsers() async {
  var url = "${domain}/users";
  var response = await http.get(
      // Encode the url
      Uri.encodeFull(url),
      // Only accept JSON response
      headers: {"Accept": "application/json"});

  // Logs the response body to the console
  print("------GetAllUsers:\n${response.body}");

  return _parseJSON(response.body, null);
}

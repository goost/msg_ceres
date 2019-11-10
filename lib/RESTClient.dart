/**
 * Provider for RESTful Futures
 */

import 'dart:async';
import 'package:MSG/PODO.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String domain =
    "http://msg-lunchserver6.westeurope.azurecontainer.io:8080";

dynamic _parseJSON(String body) {
  var responseConvertedToJson = json.decode(body);
  return responseConvertedToJson;
}

Future<bool> voteForChoice(
    int userId, int groupId, int electionId, int choiceId) async {
  var url =
      '$domain/groups/${groupId}/elections/${electionId}/votes/${userId}/${choiceId}';
  var response = await http.post(
    Uri.encodeFull(url),
  );
  print('("------voteForChoice:${response.statusCode}\n${response.body}');
  return Future.value(response.statusCode == 200);
}

Future<bool> deleteVoteforChoice(
    int userId, int groupId, int electionId) async {
  var url = '$domain/groups/${groupId}/elections/${electionId}/votes/${userId}';
  var response = await http.delete(Uri.encodeFull(url));
  print('("------DeleteVoteforChoice:${response.statusCode}\n${response.body}');
  return Future.value(response.statusCode == 200);
}

Future<List<Choice>> getAllChoicesForElectionWithVotes(
    int groupId, int electionId) async {
  var votesF = getAllVotesForElection(groupId, electionId);
  var choicesF = getChoicesForElectionInGroup(groupId, electionId);
  var votes = await votesF;
  var choices = await choicesF;

  print('Votes');
  votes.forEach((it) => print(it.choice.name));
  choices.forEach((it) => print(it.name));

  return choices
      .map((it) => Choice(
          id: it.id,
          name: it.name,
          description: it.description,
          numberOfVotes: votes.where((itz) => itz.choice.id == it.id).length))
      .toList();
}

Future<List<Vote>> getAllVotesForElection(int groupId, int electionId) async {
  var url = "${domain}/groups/${groupId}/elections/${electionId}/votes";
  var response = await http.get(
      // Encode the url
      Uri.encodeFull(url),
      // Only accept JSON response
      headers: {"Accept": "application/json"});

  // Logs the response body to the console
  print(
      "------GetAllVotesForElection:${response.statusCode}\n${response.body}");

  var rawJson = _parseJSON(response.body) as List;
  return rawJson.map((i) => Vote.fromJson(i)).toList();
}

Future<List<Choice>> getChoicesForElectionInGroup(
    int groupId, int electionid) async {
  var url = "${domain}/groups/${groupId}/elections/${electionid}/choices";
  var response = await http.get(
      // Encode the url
      Uri.encodeFull(url),
      // Only accept JSON response
      headers: {"Accept": "application/json"});

  // Logs the response body to the console
  print(
      "------GetChoicesForElectionInGroup:${response.statusCode}\n${response.body}");

  var rawJson = _parseJSON(response.body) as List;
  return rawJson.map((i) => Choice.fromJson(i)).toList();
}

Future<List<User>> getAllUsers() async {
  var url = "${domain}/users";
  var response = await http.get(
      // Encode the url
      Uri.encodeFull(url),
      // Only accept JSON response
      headers: {"Accept": "application/json"});

  // Logs the response body to the console
  print("------GetAllUsers:${response.statusCode}\n${response.body}");

  var rawJson = _parseJSON(response.body) as List;
  return rawJson.map((i) => User.fromJson(i)).toList();
}

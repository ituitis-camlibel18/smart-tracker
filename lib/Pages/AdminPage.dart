/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sample_app/Views/UserView.dart';
import 'dart:math' as math;

import '../Components/Sidebar.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List itemKeys = [];
  List<dynamic> tempKeys = [];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {


    try {
      String graphQLDocument = '''query ListUsers {
    listUsers{
    username
    email
    sub
    }
    
    
  }''';
      var operation = Amplify.API
          .query(request: GraphQLRequest<String>(document: graphQLDocument));
      var response;

      response = await operation.response;

      var data = response.data;
      var jsonData = jsonDecode(response.data);
      print(data);
      setState(() {
        tempKeys = jsonData["listUsers"];
      });

      //print(tempKeys);
    } catch (e) {
      print('List Err: ' + e.toString());
    }
  }

  void _redirect(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void showdeletecontent(username) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            'Warning',
            style: TextStyle(color: Colors.red),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Are you sure you want to delete the user?'),
                new ElevatedButton(
                  child: new Text('Close Window'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.black12),
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        String graphQLDocument =
                        '''mutation DeleteUser(\$username: String!) {
 deleteUser(username: \$username)
}`''';
                        var operation = Amplify.API.mutate(
                            request: GraphQLRequest<String>(
                                document: graphQLDocument,
                                variables: {
                                  'username': username,
                                }));
                        var response;

                        response = await operation.response;
                        _loadImages();
                        var data = jsonDecode(response.data)["deleteUser"];
                        Navigator.of(context).pop();
                      } catch (e) {
                        print(e);
                      }
                    },
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Delete User")),
              ],
            ),
          ),
          actions: [],
        );
      },
    );
  }

  void _showcontent(tempKey) {
    print(tempKey["update_time"]);
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('User'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                Card(
                    color:
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(0.4),
                    surfaceTintColor: Colors.black,
                    child: ListTile(
                      title: Text(tempKey["username"]),
                      subtitle: Text(tempKey["email"]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(tempKey["username"][0].toUpperCase()),
                      ),
                    )),

                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showdeletecontent(tempKey["username"]);
                    },
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Delete User")),





              ],
            ),
          ),
          actions: [
            new ElevatedButton(
              child: new Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black12),
            ),
          ],
        );
      },
    );
  }

  void _showaddlink() {
    final linkNameController = TextEditingController();
    final linkTextController = TextEditingController();
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return new AlertDialog(
            title: new Text('Insert User'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  TextFormField(
                    controller: linkNameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.info),
                      hintText: 'Example',
                      labelText: 'Username*',
                    ),
                  ),
                  TextFormField(
                    controller: linkTextController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.info),
                      hintText: 'example@example.com',
                      labelText: 'Email*',
                    ),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var linkName = linkNameController.text.trim();
                        var linkText = linkTextController.text.trim();
                        try {
                          var link = {"link": linkText, "name": linkName};

                          String graphQLDocument =
                          '''mutation InsertUser(\$username: String!,\$email: String!) {
 insertUser(username: \$username,email: \$email)
}`''';
                          var operation = Amplify.API.mutate(
                              request: GraphQLRequest<String>(
                                  document: graphQLDocument,
                                  variables: {
                                    'username': linkName,
                                    'email': linkText
                                  }));
                          var response;

                          response = await operation.response;
                          _loadImages();
                          var data = jsonDecode(response.data)["insertUser"];

                          if (data.toString() == "true") {
                            Navigator.of(context).pop();
                          } else {
                            print(data);
                            setState(() {
                              errorMessage =
                              "Please provide a valid username and email";
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Add User"))
                ],
              ),
            ),
            actions: [
              new ElevatedButton(
                child: new Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    errorMessage = "";
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:MyDrawer(),
      appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Admin Dashboard"), UserView()])),
      body: ListView.builder(
          itemCount: tempKeys.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  _showcontent(

                      tempKeys[index]);
                },
                child: Card(
                    color:
                    Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(0.4),
                    surfaceTintColor: Colors.black,
                    child: ListTile(
                      title: Text(tempKeys[index]["username"]),
                      subtitle: Text(tempKeys[index]["email"]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                            tempKeys[index]["username"][0].toUpperCase()),
                      ),
                    )));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showaddlink();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

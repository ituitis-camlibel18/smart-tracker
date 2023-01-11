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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      String graphQLDocument = '''query GetLinks {
    getLinks{
    filter
    tracktion_name
	  current_value
	  sk
	  pk
	  previous_value
	  update_time
    }
    
    
  }''';
      var operation = Amplify.API
          .query(request: GraphQLRequest<String>(document: graphQLDocument));
      var response;

      response = await operation.response;

      var data = response.data;
      var jsonData = jsonDecode(response.data);
      setState(() {
        tempKeys = jsonData['getLinks'];
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

  void showdeletecontent(sk) {
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
                new Text('Are you sure you want to delete the link?'),
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
                            '''mutation DeleteLink(\$sk: String!) {
 deleteLink(sk: \$sk)
}`''';
                        var operation = Amplify.API.mutate(
                            request: GraphQLRequest<String>(
                                document: graphQLDocument,
                                variables: {
                              'sk': sk,
                            }));
                        var response;

                        response = await operation.response;
                        _loadImages();
                        var data = jsonDecode(response.data)["deleteLink"];
                        Navigator.of(context).pop();
                      } catch (e) {
                        print(e);
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Delete Link")),
              ],
            ),
          ),
          actions: [],
        );
      },
    );
  }

  void _showcontent(url, sk, tempKey) {
    print(tempKey["update_time"]);
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Link'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                Card(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.4),
                    surfaceTintColor: Colors.black,
                    child: ListTile(
                      title: Text(tempKey["tracktion_name"]),
                      subtitle: Text(tempKey["filter"]
                          .split("#")[2]
                          .replaceAll("link", "Link: ")),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(tempKey["tracktion_name"][0].toUpperCase()),
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      _redirect(url);
                    },
                    child: Text("Redirect to the page")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      showdeletecontent(sk);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Delete Link")),

                Text("Recent Update Times: "),
                ListView.builder(

                  itemCount: tempKey["update_time"].length,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Card(
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.4),
                          surfaceTintColor: Colors.black,
                          child: ListTile(
                            title: Text(tempKey["update_time"][index]),

                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.access_time),
                            ),
                          )),
                    );
                  },
                ),
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
            title: new Text('Add Link'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  TextFormField(
                    controller: linkNameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.info),
                      hintText: 'Example',
                      labelText: 'Traction Name*',
                    ),
                  ),
                  TextFormField(
                    controller: linkTextController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.info),
                      hintText: 'https:/www.example.com',
                      labelText: 'Link Text*',
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
                              '''mutation InsertLink(\$name: String!,\$link: String!) {
 insertLink(name: \$name,link: \$link)
}`''';
                          var operation = Amplify.API.mutate(
                              request: GraphQLRequest<String>(
                                  document: graphQLDocument,
                                  variables: {
                                'name': linkName,
                                'link': linkText
                              }));
                          var response;

                          response = await operation.response;
                          _loadImages();
                          var data = jsonDecode(response.data)["insertLink"];

                          if (data.toString() == "true") {
                            Navigator.of(context).pop();
                          } else {
                            print(data);
                            setState(() {
                              errorMessage =
                                  "Please check the link and traction name information";
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Add Link"))
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
      appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Main Page"), UserView()])),
      body: ListView.builder(
          itemCount: tempKeys.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  _showcontent(
                      tempKeys[index]["filter"]
                          .split("#")[2]
                          .replaceAll("link", ""),
                      tempKeys[index]["sk"],
                      tempKeys[index]);
                },
                child: Card(
                    color:
                        Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.4),
                    surfaceTintColor: Colors.black,
                    child: ListTile(
                      title: Text(tempKeys[index]["tracktion_name"]),
                      subtitle: Text(tempKeys[index]["filter"]
                          .split("#")[2]
                          .replaceAll("link", "Link: ")),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                            tempKeys[index]["tracktion_name"][0].toUpperCase()),
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

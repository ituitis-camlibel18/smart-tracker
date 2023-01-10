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

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

import 'package:sample_app/Views/UserView.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> itemKeys = [];

  @override
  void initState() {
    super.initState();
   // _loadImages();
  }

  void _loadImages() async {
    try {
      String graphQLDocument = '''query FirstRun {
    firstRun
  }''';
      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(document: graphQLDocument)
      );

      var response = await operation.response;
      var data = response.data;

      print('Query result: ' + data.toString());
    } catch (e) {
      print('List Err: ' + e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Main Page"), UserView()])),
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return Text("index");
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         _loadImages();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

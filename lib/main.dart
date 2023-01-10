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

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/Pages/LoadingPage.dart';

import 'Pages/LandingPage.dart';
import 'Pages/MainPage.dart';

/*
IMPORTANT - THIS LINE WILL NOT COMPILE
That is intentional

You need to generate your own amplifyconfiguration.dart
for accessing your own AWS resources.

You will use the Amplify CLI tool for that.  Please read the
README.md contained within the root of this project to learn
about what you'll need to do.
 */

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isAmplifyConfigured = false;
  bool _isLoggedIn = false;

  @override
  initState() {
    super.initState();
    _initAmplifyFlutter();
  }

  void _initAmplifyFlutter() async {
    AmplifyAuthCognito auth = AmplifyAuthCognito();
    final api = AmplifyAPI();
    Amplify.addPlugin(AmplifyAPI());


    Amplify.addPlugins([auth]);

    // Initialize AmplifyFlutter
    try {
      await Amplify.configure(''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
   
     "aws_appsync_graphqlEndpoint": "https://mplvhmebgfbopbmp3tzc2lthiu.appsync-api.eu-central-1.amazonaws.com/graphql",
    "aws_appsync_region": "eu-central-1",
    "aws_appsync_authenticationType": "AMAZON_COGNITO_USER_POOLS",
    "aws_appsync_apiKey": "da2-xokehcaf3bfqhfszxsdz7xn3pa",
  

    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "smart-tracker": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://mplvhmebgfbopbmp3tzc2lthiu.appsync-api.eu-central-1.amazonaws.com/graphql",
                    "region": "eu-central-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS",
                    "apiKey": "da2-xokehcaf3bfqhfszxsdz7xn3pa"
                    
                }
            }
        }
    },
 
  
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-central-1_ZzS9ZHkTV",
                        "AppClientId": "5sj3md73tak5292chs88vqchmp",
                        "Region": "eu-central-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_UPPERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    }
}''');
      try{
      var user = await Amplify.Auth.getCurrentUser();
      setState(() {
        _isLoggedIn = true;
      });
      }catch(e){
       print("no user");

      };
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }

    setState(() {
      _isAmplifyConfigured = true;
    });
  }

  Widget _display() {
    if (_isAmplifyConfigured) {
      if(_isLoggedIn){
        return MainPage();
      }
      return LandingPage();
    } else {
      return LoadingPage();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Amplify App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: _display());
  }
}

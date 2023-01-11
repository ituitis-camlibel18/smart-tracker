import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_app/Pages/AdminPage.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../Pages/MainPage.dart';



class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();

}

class _MyDrawerState extends State<MyDrawer> {
  var isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkIsAdmin();
  }
   void _checkIsAdmin()async{

     String graphQLDocument = '''query IsAdmin {
    isAdmin
    
    
  }''';
     var operation = Amplify.API
         .query(request: GraphQLRequest<String>(document: graphQLDocument));
    ;

     var response;

     response = await operation.response;

     var data = jsonDecode(response.data)["isAdmin"];
     if(data.toString()=="true"){

       setState(() {
         isAdmin = true;
       });

     };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Sidebar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Traction Page'),
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
            },
          ),

    isAdmin==true?ListTile(
            title: Text('Admin Dashboard'),
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => AdminPage()), (route) => false);;
            },
          ):ListTile(

    ),
        ],
      ),
    );
  }
}
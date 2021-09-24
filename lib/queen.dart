import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Queen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Welcome'),centerTitle: true,actions: [IconButton(icon: Icon(Icons.logout),
         onPressed: (){FirebaseAuth.instance.signOut();})],),
   );
  }

}



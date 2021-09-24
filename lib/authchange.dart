import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
//import 'package:login/excep.dart';

class Autho with ChangeNotifier{
  final googleSignIn=GoogleSignIn();
  String tok;
  String useor;
  List  phone=[];
  DateTime exp;
  GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  Future googlelog() async {

    final googleus= await googleSignIn.signIn();
    if(googleus==null)
      return;
    _user=googleus;
    final googleauth= await googleus.authentication;
    final cred=GoogleAuthProvider.credential(
      accessToken: googleauth.accessToken,
      idToken: googleauth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(cred);


    notifyListeners();
  }
  Future loginemail(var email,var pass) async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email:email ,password:pass );
  }
  Future sigupemail(String email,String pass) async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email ,password:pass );
  }

  Future signout() async{

    FirebaseAuth.instance.currentUser.delete();

   await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }


  Future<void> signup(String email,String pass) async{
   //return authen(email, pass, 'signUp');
   final url=Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD4_ospSbcrk6dFb1zNTlaq-mPUhXz9m3g");
   //try {
     final res = await http.post(url, body: json.encode({
       "email": email,
       "password": pass,
       "returnSecureToken": true
     })
     );
     print(json.decode(res.body));
     print("yessssssssssssssssssssssss");
    // final re=json.decode(res.body);
   //  if(re["error"]!=null){
    //   throw  HttpException(re['error']['message']);
    // }
   //}catch(error){
   //  throw error;
  // }

  }
  Future<void> loginwith(String email,String pass) async {
    // return authen(email, pass, 'signInWithPassword');
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD4_ospSbcrk6dFb1zNTlaq-mPUhXz9m3g");
    // try {
    final res = await http.post(url, body: json.encode({
      "email": email,
      "password": pass,
      "returnSecureToken": true
    })
    );
    print(json.decode(res.body));
  }
  notifyListeners();
}
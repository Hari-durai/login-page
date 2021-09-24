import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginpage1/authchange.dart';
import 'package:loginpage1/queen.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:
  Myapp() ));
}

enum Auth{
  Singup,
  login
}
var a=FirebaseAuth.instance.currentUser;

class Myapp extends StatelessWidget {
  //var a=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (ctx) => Autho(),
        child: StreamBuilder<User>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else if(snapshot.hasData) {
                    return Queen();
                  } else if(snapshot.hasError) {
                    return Center(child: Text("Some thing went wrong"),);
                  }
                  else{
                    return Home();
                  }

                },



        ),
      ),
    );
  }


}
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(children: [
        Container(color: Colors.greenAccent,),
        Container(height: double.infinity,width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: Text("Hello"),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.deepOrangeAccent),
                padding: EdgeInsets.all(20),
              ),
              Flexible(child: Authscre())
            ],
          ),
        )
      ],),



    );
  }

}

class Authscre extends StatefulWidget{
  @override
  Aath createState() {
    // TODO: implement createState
    return  Aath();
  }
}

class  Aath extends  State<Authscre>{
  final GlobalKey<FormState> _formKey = GlobalKey();
  Auth auth=Auth.login;
  final pass=TextEditingController();
  var erormeg='';
  Map<String, String> data={
    "email":'',
    'password':''
  };
  void show( String message){
    showDialog(context: context, builder: (ctx)=>
        AlertDialog(content: Text(message),title: Text(erormeg),actions: [
          TextButton(onPressed:()=>Navigator.of(context).pop(), child:Text("Okay"))
        ],)
    );
  }
  Future<void> submit() async{

      final valid=_formKey.currentState.validate();
      if(valid){
    _formKey.currentState.save();
    }
    try {
      if (auth == Auth.login) {
        await Provider.of<Autho>(context, listen: false).loginemail(
            data['email'], data['password']);
      }
      else {
        await Provider.of<Autho>(context, listen: false).sigupemail(
            data['email'], data['password']);
      }
    }on PlatformException catch(err){
       show(err.message);



    } catch(err){
        show(err.toString());
    }

  }
  void _switch(){
    if (auth == Auth.login) {
      setState(() {
        auth = Auth.Singup;
      });
    } else {
      setState(() {
        auth = Auth.login;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        height: auth==Auth.Singup?360:300,
        width: MediaQuery.of(context).size.width * 0.75,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (str){
                    if(str.isEmpty|| !str.contains('@') || !str.contains('.com')){
                      return "Invalid";
                    }
                    return null;
                  },
                  onSaved: (str){
                    data['email']=str;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller:pass,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    data['password'] = value;
                  },
                ),
                if(auth==Auth.Singup)
                  TextFormField(
                      decoration: InputDecoration(labelText: "Confirm Password"),
                      enabled: auth==Auth.Singup,
                      obscureText: true,
                      validator: auth==Auth.Singup?(str){
                        if(str!=pass.text)
                          return "Wrong password";
                        return null;
                      }:null


                  ),
                ElevatedButton(
                  child:
                  Text(auth == Auth.login ? 'LOGIN' : 'SIGN UP'),
                  onPressed: submit,
                  style: ButtonStyle( shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      )
                  ),
                ),
                TextButton(onPressed: _switch, child: Text(auth==Auth.login?"SIGN UP":"LOGIN")),
                Text(" OR"),
                TextButton(
                  //style: ButtonStyle(shape: MaterialStateProperty.all<TextDecoration.underline> ),
                  child:Text("signin with google",style:TextStyle(decoration: TextDecoration.underline,)),
                  onPressed: (){
                    Provider.of<Autho>(context, listen: false).googlelog();
                  },

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

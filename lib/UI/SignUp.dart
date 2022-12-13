
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Sections.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
return SignUpState();
  }

}class SignUpState extends State<SignUp>{
  bool isLoading = false;
  String? gender="male";
  String? role="manger";
  TextEditingController name=new TextEditingController();
  TextEditingController password=new TextEditingController();
  TextEditingController email=new TextEditingController();

  addData() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    var userspref = FirebaseFirestore.instance.collection("Users");
    userspref.add({
      "name": name.text,
      "email": email.text,
      "kind": gender,
      "role": role,
      "created_at": date,
      "password":password.text
    });
  }
  signUp() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      addData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:
         Container(
           decoration:
           BoxDecoration(
             image:DecorationImage(image:  AssetImage("images/signUp.jpg"),fit: BoxFit.fill ),

       ),
         child:  Form(

           child:

          SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 16.0),
             scrollDirection: Axis.vertical,

            child:
            Container(height: MediaQuery.of(context).size.height,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(alignment: Alignment.center,
                   // padding: EdgeInsets.only(left: 20),
                    child:
                    TextFormField(
                      controller: name,
                      textCapitalization: TextCapitalization.words,


                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                      labelText:'Name',

                    labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
                  ),
                ) ,

                //color: Colors.blueGrey
                ),
                Container(alignment: Alignment.center,
                  // padding: EdgeInsets.only(left: 20),
                  child:TextFormField(
                    controller: email,
                    textCapitalization: TextCapitalization.words,


                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.mail),
                        labelText:'Email',

                        labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
                    ),
                  ) ,

                  //color: Colors.blueGrey
                ),
                Container(alignment: Alignment.center,
                  // padding: EdgeInsets.only(left: 20),
                  child:TextFormField(
                    controller: password,
                    textCapitalization: TextCapitalization.words,
obscureText: true,

                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(Icons.password),
                        labelText:'Password',

                        labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
                    ),
                  ) ,

                  //color: Colors.blueGrey
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text("Gender",style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.only(top: 10)),
                CupertinoRadioChoice(
                    choices: {'male' : 'Male', 'female' : 'Female', 'other': 'Other'},
                    onChange: (selectedGender) {gender=selectedGender;},
                    initialKeyValue: 'male'),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text("Role",style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.only(top: 10)),
                CupertinoRadioChoice(
                    choices: {'manger' : 'manger', 'employee' : 'Employee'},
                    onChange: (selected) {role = selected;},
                    initialKeyValue: 'male'),
                Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/5)),
                (isLoading==false) ?  ElevatedButton(

                   onPressed: ()async{
                     setState((){
                       isLoading=true;
                     });
                     await signUp();
                     setState((){
                       isLoading=false;
                     });
                     Navigator.push(context,MaterialPageRoute(builder: (context)=>Section()));
                     }, child: Text("Sign Up",style: TextStyle(fontSize: 30),)): Center(child:CircularProgressIndicator())

              ],) ,)


           ),
         ) ,)

   );
  }

}
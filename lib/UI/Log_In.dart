import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/UI/SignUp.dart';
import 'Sections.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  String role = "";
  GlobalKey<FormState>formStateLogin=new GlobalKey<FormState>();
  TextEditingController password = new TextEditingController();
  TextEditingController email = new TextEditingController();

  getRole() async {
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("email", isEqualTo: email.text).get();
    setState(() {
      role = query.docs[0]["role"];
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", role!);
  }

  login() async {
    var formData=formStateLogin.currentState;
    if(formData!.validate()) {
      formData.save();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);
      await getRole();

      String? id = userCredential.user?.uid;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("id", id!);
      await prefs.setString('email', email.text);
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("No user found for that email."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text("Cancel"))
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        AlertDialog(
          content: Text("Wrong password provided for that user."),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text("Cancel"))
          ],
        );
        // print('Wrong password provided for that user.');
      }
    }}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 10,right: 10,top: 30),
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("images/signUp.jpg"), fit: BoxFit.fill),
          ),
          child:Card(elevation: 5,child:    Form(
            key: formStateLogin,
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: Column(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Field is required.';
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.mail),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ),

                            //color: Colors.blueGrey
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: password,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Field is required.';
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.password),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold)),
                            ),

                            //color: Colors.blueGrey
                          ),
                        ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 10)),
                      (isLoading == false)
                          ?
                      ElevatedButton(
style: ElevatedButton.styleFrom(
  backgroundColor:Colors.black ,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    textStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await login();
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Section(role)),
                                    (Route<dynamic> route) => false);
                          },

                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 30),
                          ))
                          : Center(child: CircularProgressIndicator()),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        child: Text("Don't have an account"),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                                  (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  ),
                )),
          ),)
       ,
        ) ,
        );
  }
}

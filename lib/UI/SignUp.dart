
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/UI/Log_In.dart';
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
  LatLng startLocation = LatLng(30.044420, 31.235712);
  String? lat;
  String? lang;
  GoogleMapController? mapController;
  Set<Marker>myMarker={
    Marker(markerId: MarkerId("1"),position:LatLng(30.044420, 31.235712) )
  };
  TextEditingController name=new TextEditingController();
  TextEditingController password=new TextEditingController();
  TextEditingController email=new TextEditingController();
  GlobalKey<FormState>formStateSignUp=new GlobalKey<FormState>();
   String? validatePassword(String ?value) {
    if (value==null)
      return 'Password Can not Empty';
    else if (value!.trim().length<8)
      return 'Password Can not less than 8 charً';
  else  if(value!.trim().length>12)
      return 'Password Can not more than 8 charً';
  }

  createUser(String id) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var userspref = FirebaseFirestore.instance.collection("Users");
    userspref.add({
      "id":id,
      "name": name.text,
      "email": email.text,
      "kind": gender,
      "role": role,
      "created_at": date,
      "password":password.text
      ,"lat":lat,
      "lang":lang
    });
  }
  signUp() async {
    var formData=formStateSignUp.currentState;
    if(formData!.validate()) {
      formData.save();
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        String? id=  credential.user?.uid;
        print(id);
        createUser(id!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", id);
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Section(role.toString())),(Route<dynamic> route) => false);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("The password provided is too weak."),
                actions: [
                  ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));}, child:Text("Cancel") )],
              );
            },
          );
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("The account already exists for that email."),
                actions: [
                  ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));}, child:Text("Cancel") )],
              );
            },
          );
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:
         Container(

             padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/18),
           decoration:
           BoxDecoration(
             borderRadius: BorderRadius.circular(33)
             //image:DecorationImage(image:  AssetImage("images/signUp.jpg"),fit: BoxFit.fill ),

       ),
         child:  Form(
             key: formStateSignUp,
           child:

          SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 16.0),
             scrollDirection: Axis.vertical,

            child:

                Card(elevation: 3,
                    borderOnForeground: true,child:    Container(
                 // height: MediaQuery.of(context).size.height,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(

                        child: Column(children: [
                          Container(

                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20,top:70),
                            child:
                            TextFormField(
                              controller: name,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Field is required.';
                                return null;
                              },

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
                            padding: EdgeInsets.only(left: 20),
                            child:TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Field is required.';
                                return null;
                              },
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
                            padding: EdgeInsets.only(left: 20),
                            child:TextFormField(
                              validator:validatePassword,
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
                        ]),),


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
                          choices: {'manger' : 'manger', 'employee' : 'Employee' ,"worker":"worker"},
                          onChange: (selected) {role = selected;},
                          initialKeyValue: 'male'),
                      Card(child:
                      Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height / 4,
                        child: Stack(children: [
                          GoogleMap(
                            //Map widget from google_maps_flutter package
                            zoomGesturesEnabled: true, //enable Zoom in, out on map
                            initialCameraPosition: CameraPosition(
                              //innital position in map
                              target: startLocation, //initial position
                              zoom: 14.0, //initial zoom level
                            )
                            ,
                            markers: myMarker,
                            mapType: MapType.normal,
                            onTap: (latlang){
                              setState(() {
                                myMarker.remove(Marker(markerId: MarkerId("1")));
                                myMarker.add( Marker(markerId: MarkerId("1"),position:latlang ));
                                lat=latlang.latitude.toString();
                                lang=latlang.longitude.toString();
                              });
                              print(latlang.latitude);

                            },//map type
                            onMapCreated: (controller) {
                              //method called when map is created
                              setState(() {
                                mapController = controller;
                              });
                            },
                          ),

                        ]),
                      ), elevation: 5,color: Colors.white),
                      Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/20)),
                      (isLoading==false) ?
                      ElevatedButton(

                          onPressed: ()async{
                            setState((){
                              isLoading=true;
                            });
                            await signUp();
                            setState((){
                              isLoading=false;
                            });
                               },style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.black ,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold))
                          ,child: Text("Sign Up",style: TextStyle(fontSize: 30),)): Center(child:CircularProgressIndicator())
              ,Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/30)),
                       InkWell(child: Text("I have an account"),
                          onTap:(){Navigator.pushAndRemoveUntil(
                              context
                              ,MaterialPageRoute(builder: (context)=>Login()),(Route<dynamic> route) => false);} )
                      ,Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/30))
                    ],) ,) ,)


           ),
         ) ,)

   );
  }

}
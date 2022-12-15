import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/UI/Log_In.dart';
import 'package:untitled3/UI/Myapplication.dart';
import 'package:untitled3/UI/Setting.dart';
import 'package:untitled3/UI/addSection.dart';
import 'package:untitled3/UI/sectionDetail.dart';

import 'Jobs.dart';


class Section extends StatefulWidget {
  String role;


  Section(this.role);

  @override
  State<StatefulWidget> createState() {
    return SectionState(this.role);
  }

}

class SectionState extends State<Section> {
  String role;
  SectionState(this.role);
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if(index==0){

    }
    if(index==1){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>MyApplication()));


    }
    if(index==2){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting()));

    }
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }
  CollectionReference sectionRef = FirebaseFirestore.instance.collection(
      "Section");

signOut() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Login()),(Route<dynamic> route) => false);

}
@override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      (role=="manger")?
      Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: () async {signOut();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('email');
          prefs.remove('id');
          prefs.remove('theme');}, icon:Icon(Icons.logout_sharp)),
          IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting()));
          }, icon:Icon(Icons.settings)),
        ]),
        backgroundColor: Colors.black,
      body: Container(color: Colors.black,child:StreamBuilder<dynamic>(stream: sectionRef.snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr");
              }
              if(snapshots.hasData){
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            //childAspectRatio: 3 / 2,
                          ),
                          itemCount: snapshots.data.docs!.length,
                          itemBuilder: (BuildContext context, int postion) {
                            return  Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 4,
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
                                child: InkWell(
                                  child: Column(children: [
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 5,

                                      //margin: EdgeInsets.only(top: 50),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage("${snapshots.data.docs[postion].data()["image"]}"), fit: BoxFit.fill)),
                                    ),
                                    Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Text(
                                          "${snapshots.data.docs[postion].data()["name"]}" ,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  onTap: () {
                                    showDialog(context: context, builder: (
                                        BuildContext context) {
                                      return
                                        AlertDialog(
                                          title: Text("please select"),
                                          actions: [
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.update),
                                                  Text("Update Section")
                                                ],
                                              )
                                              , onTap: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>SectionDetail(snapshots.data.docs[postion].id,"${snapshots.data.docs[postion].data()["image"]}", "${snapshots.data.docs[postion].data()["name"]}" )));
                                            },
                                            ),
                                            Padding(padding: EdgeInsets.all(10),),
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.work),
                                                  Text("show Jobs")
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs("${snapshots.data.docs[postion].id}",role.toString())));
                                              },
                                            )
                                            //onTap: uplodImages(),

                                          ],
                                        );
                                    });

                                  },
                                ));
                            // return _buildCard(
                            // snapshots.data.docs[postion].data()["title"],
                            //  " ${snapshots.data.docs[postion].data()["image"]}",
                            // context);

                          },
                        )),
                    SizedBox(height: 15.0)
                  ],
                );

              }

              return Center(child: CircularProgressIndicator());
            }
        ) ,),
      floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSection()));
    },child: Icon(Icons.add)),



      ):
      Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue,

            actions: [
              IconButton(onPressed: () async {signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              prefs.remove('id');
            prefs.remove('theme');
            }, icon:Icon(Icons.logout_sharp)),
              IconButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting()));
              }, icon:Icon(Icons.settings)),
            ]),

        backgroundColor: Colors.black,
        body: Container(color: Colors.black,child:StreamBuilder<dynamic>(stream: sectionRef.snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr");
              }
              if(snapshots.hasData){
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            //childAspectRatio: 3 / 2,
                          ),
                          itemCount: snapshots.data.docs!.length,
                          itemBuilder: (BuildContext context, int postion) {
                            return  Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 4,
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
                                child: InkWell(
                                  child: Column(children: [
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 5,

                                      //margin: EdgeInsets.only(top: 50),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage("${snapshots.data.docs[postion].data()["image"]}"), fit: BoxFit.fill)),
                                    ),
                                    Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Text(
                                          "${snapshots.data.docs[postion].data()["name"]}" ,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  onTap: () {
                                    showDialog(context: context, builder: (
                                        BuildContext context) {
                                      return
                                        AlertDialog(
                                          title: Text("please select"),
                                          actions: [

                                            Padding(padding: EdgeInsets.all(10),),
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.work),
                                                  Text("show Jobs")
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs("${snapshots.data.docs[postion].id}",role)));
                                              },
                                            )
                                            //onTap: uplodImages(),

                                          ],
                                        );
                                    });

                                  },
                                ));


                          },
                        )),
                    SizedBox(height: 15.0)
                  ],
                );

              }

              return Center(child: CircularProgressIndicator());
            }
        ) ,),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'My application',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          )


      )

    ;
    }

  }
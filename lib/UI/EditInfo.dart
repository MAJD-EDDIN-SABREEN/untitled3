import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfo extends StatefulWidget {
  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  List<Widget> skills = [];
  String Id = "";
  String userId = "";
  TextEditingController skill = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController expactedSal = new TextEditingController();
  TextEditingController workPos = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  List SkillsString = [];
  Set<Marker>?myMarker;
  GoogleMapController? mapController;
  String ?lat;
  String ?lang;
  LatLng ?startLocation;
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = (await prefs.getString('id'))!;
    setState(() {});
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("id", isEqualTo: Id).get();
    setState(() {
      name.text = query.docs[0]["name"];
      workPos.text = query.docs[0]["workPostion"];
      expactedSal.text = query.docs[0]["expactedsalary"];
      print("${query.docs[0]["skills"][1]}");
      SkillsString=query.docs[0]["skills"];
      lat =query.docs[0]["lat"];
      lang =query.docs[0]["lang"];

      phone.text=(query.docs[0]["phone"]).toString();
    });
    setState(() {
      startLocation = LatLng(double.parse(lat!), double.parse(lang!));
      myMarker ={
        Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat!), double.parse(lang!)) )
      };
    });
  }

  getUserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = (await prefs.getString('id'))!;
    setState(() {});
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("id", isEqualTo: Id).get();
    setState(() {
      userId = query.docs[0].id;

    });
  }

  onAddSkills(String skill) {
    setState(() {
      skills.add(InkWell(
        child: Flexible(
            child: Card(
          child: Text(skill),
        )),
        onTap: () {},
      ));
      SkillsString.add(skill);
      print(skills);
    });
  }

  updateData() async {
    await getUserid();
    var userspref = FirebaseFirestore.instance.collection("Users").doc(userId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.set(
            userspref,
            {
              "name": name.text,
              "workPostion": workPos.text,
              "expactedsalary": expactedSal.text,
              "skills": SkillsString,
              "phone": phone.text
            },
            SetOptions(merge: true));
      } else {
        print("no");
      }
    });
  }

  @override
  void initState() {
    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    startLocation = LatLng(double.parse(lat!), double.parse(lang!));
    myMarker ={
      Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat!), double.parse(lang!)) )
    };
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Icon(
                  Icons.person,
                  size: MediaQuery.of(context).size.width / 4,
                )),
              ),
            ),
            Card(
              elevation: 2,
              child: TextFormField(
                controller: name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: 'name',
                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 30),
              elevation: 2,
              child: TextFormField(
                controller: workPos,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.work),
                    labelText: 'work postion',
                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 30),
              elevation: 2,
              child: TextFormField(
                controller: phone,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.phone),
                    labelText: 'Phone',
                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 30),
              elevation: 2,
              child: TextFormField(
                controller: expactedSal,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.attach_money),
                    labelText: 'Expected salary',
                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
                margin: EdgeInsets.only(top: 30),
                elevation: 2,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: skill,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          filled: true,
                          icon: Icon(Icons.skateboarding),
                          labelText: 'Skills',
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                    )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            onAddSkills(skill.text);
                            print(skills);
                          });
                        },
                        icon: Icon(Icons.add))
                  ],
                )),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            (skills.isNotEmpty)
                ? Row(
                    children: skills!,
                  )
                :
            Center(child: Text(SkillsString.toString()),),
            Container(height: MediaQuery.of(context).size.height/4,child: GoogleMap(
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: startLocation!, //initial position
                zoom: 14.0, //initial zoom level
              )
              ,
              markers: myMarker!,
              mapType: MapType.normal,
              onTap: (latlang){
                setState(() {
                  myMarker!.remove(Marker(markerId: MarkerId("1")));
                  myMarker!.add( Marker(markerId: MarkerId("1"),position:latlang ));
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
            ) ,),
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    updateData();
                  },
                  child: Text("Update")),
            )
          ],
        ),
      ),
    );
  }
}

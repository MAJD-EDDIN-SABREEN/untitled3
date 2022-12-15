import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class JobDetail extends StatefulWidget {
  String id;
  String image;
  String title;
  String descrption;
  String price;
  String requirements;
  String age;
  String status;
  String sectionId;
  String lat;
  String lang;
  JobDetail(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.sectionId,this.lat,this.lang);

  @override
  State<StatefulWidget> createState() {
    return JobDetailState(
        this.id,
        this.image,
        this.title,
        this.descrption,
        this.price,
        this.requirements,
        this.age,
        this.status,this.sectionId,this.lat,this.lang);
  }

}

class JobDetailState extends State<JobDetail> {
  String id;
  String image;
  String title;
  String descrption;
  String price;
  String requirements;
  String age;
  String status;
  String sectionId;
  String lat;
  String lang;
  JobDetailState(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.sectionId,this.lat,this.lang);

  Set<Marker>?myMarker;
  GlobalKey<FormState>formStateUpdateJob=new GlobalKey<FormState>();

  GoogleMapController? mapController;

  bool isLoading = false;
  File ?file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  TextEditingController title1 = new TextEditingController();
  TextEditingController description1 = new TextEditingController();
  TextEditingController salary1 = new TextEditingController();
  TextEditingController requirements1 = new TextEditingController();
  TextEditingController age1 = new TextEditingController();
  String ?status1 ;
  LatLng ?startLocation;

  updateData(var id,BuildContext context) async {
    var formData = formStateUpdateJob.currentState;
    if (formData!.validate()) {

      formData.save();
    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(sectionId)
        .collection("Jobs")
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.update(userspref, {
          "title": title1.text,
          "description": description1.text,
          "requirement":requirements1.text,
          "age":age1.text,
          "status":status1,
          "lat":lat,
          "lang":lang,
          if(file!=null)
          "image": url.toString(),

        });
      }
      else {
        print("no");
      }
    });
      Navigator.pop(context);
  }}

  uplodImages() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.camera);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });


      //  url= await refStorage.getDownloadURL();
      print(url);
    }
    else
      print("please select image");
  }

  uplodImagesFromGallery() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });


      var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
      await refStorage.putFile(file!);

      url = await refStorage.getDownloadURL();
      //  url= await refStorage.getDownloadURL();
      print(url);
    }
    else
      print("please select image");
  }

  deleteData(var id) async {
    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(sectionId)
        .collection("Jobs");
    userspref.doc(id).delete();
  }

  @override
  void initState() {
    title1.text = title;
    description1.text = descrption;
    salary1.text = price;
    requirements1.text = requirements;
    age1.text = age;
    status1 =status;
   startLocation = LatLng(double.parse(lat), double.parse(lang));
    myMarker ={
    Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat), double.parse(lang)) )
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(scrollDirection: Axis.vertical,
      child:Form(
        key:formStateUpdateJob ,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (file == null) ?
              InkWell(child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(image)
                    )
                ),


              ),
                onTap: () {
                  showDialog(context: context, builder: (BuildContext context) {
                    return
                      AlertDialog(
                        title: Text("please select"),
                        actions: [
                          InkWell(
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt),
                                Text("From camera")
                              ],
                            )
                            , onTap: () {
                            Navigator.pop(context);
                            uplodImages();
                          },
                          ),
                          Padding(padding: EdgeInsets.all(10),),
                          InkWell(
                            child: Row(
                              children: [
                                Icon(Icons.image),
                                Text("From gallery")
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              uplodImagesFromGallery();
                            },
                          )
                          //onTap: uplodImages(),

                        ],
                      );
                  });
                },)

                  :
              InkWell(child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(file!)
                    )

                ),),
                  onTap: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return
                        AlertDialog(
                          title: Text("please select"),
                          actions: [
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt),
                                  Text("From camera")
                                ],
                              )
                              , onTap: () {
                              Navigator.pop(context);
                              uplodImages();
                            },
                            ),
                            Padding(padding: EdgeInsets.all(10),),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.image),
                                  Text("From gallery")
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                uplodImagesFromGallery();
                              },
                            )
                            //onTap: uplodImages(),

                          ],
                        );
                    });
                  })
              , Padding(padding: EdgeInsets.only(top: 10)),
              TextFormField(
                controller: title1,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Field is required.';
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.padding_rounded),
                    labelText: 'Title',

                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)
                ),
              ),
              TextFormField(
                controller: description1,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Field is required.';
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.pages_outlined),
                    labelText: 'Description',

                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)
                ),
              ),
              TextFormField(
                controller: salary1,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Field is required.';
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Salary',

                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)
                ),
              ),
              TextFormField(
                controller: requirements1,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Field is required.';
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,

                    icon: Icon(Icons.padding_rounded),
                    labelText: 'requirement',
                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
              TextFormField(
                controller: age1,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Field is required.';
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.view_agenda_outlined),
                    labelText: 'age',
                    labelStyle: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold)),
              ),
              Padding(padding:EdgeInsets.only(top: 20)),
              Row(mainAxisAlignment: MainAxisAlignment.center,

                children: [Icon(Icons.signal_wifi_statusbar_null_sharp)
                  ,Text("Status",style: TextStyle(fontWeight: FontWeight.bold),)],),
              DropDownTextField(
                padding: EdgeInsets.only(left: 50),
                dropdownRadius: 20,
                listSpace: 20,
                listPadding: ListPadding(top: 20),
                initialValue: status,
                //enableSearch: true,

                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownList: const [
                  DropDownValueModel(name: 'available', value: "T"),
                  DropDownValueModel(name: ' not available', value: "F"),
                ],
                listTextStyle: const TextStyle(color: Colors.blue),
                dropDownItemCount: 8,

                onChanged: (val) {
                  status1=val.toString();
                },
              ),
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








              Padding(padding: EdgeInsets.only(top: 30))
              , Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (isLoading == false) ?
                  ElevatedButton(onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var refStorage = FirebaseStorage.instance.ref(
                        "images/$nameImage");
                    if (file != null) {
                      await refStorage.putFile(file!);
                      url = await refStorage.getDownloadURL();
                    }
                    else {
                      url = image;
                    }
                    ;
                   // url = await refStorage.getDownloadURL();
                    await updateData(id,context);
                    setState(() {
                      isLoading = false;
                    });

                  }, child: Text("Update")) :
                  Center(child: CircularProgressIndicator()),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  (isLoading == false) ? ElevatedButton(onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await deleteData(id);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  }, child: Text("Delete")) :
                  Center(child: CircularProgressIndicator())
                ],
              )

            ]) ,
      )

      )



    );
  }

}
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddJob extends StatefulWidget {
  String sectionId;

  AddJob(this.sectionId);

  @override
  State<StatefulWidget> createState() {
    return AddJobState(this.sectionId);
  }
}

class AddJobState extends State<AddJob> {
  String sectionId;
  bool isLoading = false;
  File? file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  String? lat1;
  String? lang1;
  TextEditingController title = new TextEditingController();
  TextEditingController descrptuon = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController requirements = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController status = new TextEditingController();
  var latlong;
  String googleApikey = "AIzaSyA2dUyVmcBLkM8YqLeUorfg0biWVYM-k_U";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(30.044420, 31.235712);
  String location = "Search Location";

  AddJobState(this.sectionId);

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? gmc;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.044420, 31.235712),
    zoom: 14.4746,
  );

  addJob() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(sectionId)
        .collection("Jobs");
    userspref.add({
      "title": title.text,
      "image": url.toString(),
      "description": descrptuon.text,
      "salary": price.text,
      "requirement": requirements.text,
      "age": age.text,
      "status": status.text,

      "lat_lang":latlong.toString(),
      "created_at": date.toString()
    });
  }

  uplodImages() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.camera);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });

      //  url= await refStorage.getDownloadURL();
      print(url);
    } else
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
    } else
      print("please select image");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (file == null)
                ? Container(
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("please select"),
                                  actions: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Icon(Icons.camera_alt),
                                          Text("From camera")
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        uplodImages();
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                    ),
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
                        },
                        icon: Icon(Icons.add)),
                  )
                : InkWell(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill, image: FileImage(file!))),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("please select"),
                              actions: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("From camera")
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    uplodImages();
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
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
                    }),
            Padding(padding: EdgeInsets.only(top: 10)),
            TextFormField(
              controller: title,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.pages_outlined),
                  labelText: 'Title',
                  labelStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
            ),

            TextFormField(
              controller: descrptuon,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.padding),
                  labelText: 'Descrption',
                  labelStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            TextFormField(
              controller: price,
              textCapitalization: TextCapitalization.words,
              keyboardType:TextInputType.number ,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.monetization_on),
                  labelText: 'salary',
                  labelStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            TextFormField(
              controller: requirements,
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
              controller: age,
              textCapitalization: TextCapitalization.words,
              keyboardType:TextInputType.number ,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.view_agenda_outlined),
                  labelText: 'age',
                  labelStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            TextFormField(
              controller: status,
              keyboardType:TextInputType.number ,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.safety_divider),
                  labelText: 'status',
                  labelStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Stack(children: [
                GoogleMap(
                  //Map widget from google_maps_flutter package
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: startLocation, //initial position
                    zoom: 14.0, //initial zoom level
                  ),
                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    //method called when map is created
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),

                //search autoconplete input
                Positioned(
                    //search input bar
                    top: 10,
                    child: InkWell(
                        onTap: () async {
                          var place = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleApikey,
                              mode: Mode.overlay,
                              types: [],
                              strictbounds: false,
                              components: [Component(Component.country, 'np')],
                              //google_map_webservice package
                              onError: (err) {
                                print(err.predictions.toString());
                              });

                          if (place != null) {
                            setState(() {
                              location = place.description.toString();
                            });

                            //form google_maps_webservice package
                            final plist = GoogleMapsPlaces(
                              apiKey: googleApikey,
                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                              //from google_api_headers package
                            );
                            String placeid = place.placeId ?? "0";
                            final detail =
                                await plist.getDetailsByPlaceId(placeid);
                            final geometry = detail.result.geometry!;
                            final lat = geometry.location.lat;
                            final lang = geometry.location.lng;

                            var newlatlang = LatLng(lat, lang);
                            setState(() {
                              lat1 = lat.toString();
                              lang1 = lang.toString();
                            });

                            //move map camera to selected place with animation
                            mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: newlatlang, zoom: 17)));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Card(
                            child: Container(
                                padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width - 40,
                                child: ListTile(
                                  title: Text(
                                    location,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  trailing: Icon(Icons.search),
                                  dense: true,
                                )),
                          ),
                        )))
              ]),
            ),

            //   child:  GoogleMap(
            //     mapType: MapType.normal,
            //     initialCameraPosition: _kGooglePlex,
            //     onMapCreated: (GoogleMapController controller) {
            //      gmc=controller;
            //     },
            //   ),
            // ),

            Padding(padding: EdgeInsets.only(top: 50)),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  var refStorage =
                      FirebaseStorage.instance.ref("images/$nameImage");
                  await refStorage.putFile(file!);
                  url = await refStorage.getDownloadURL();
                  latlong = await mapController?.getLatLng(ScreenCoordinate(x: 200, y: 200));
                      setState(() {

                      });
                  addJob();
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
                child: Text("add")),
          ]),
    ));
  }
}
//AIzaSyBkwuMI2uJF1sAkzVQphO-UjaJt3ZxRuRU

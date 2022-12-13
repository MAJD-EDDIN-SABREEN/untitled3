import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddSection extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddSectionState();
  }

}
class AddSectionState extends State<AddSection>{
  bool isLoading = false;
  File ?file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  TextEditingController title=new TextEditingController();
  addData() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    var userspref = FirebaseFirestore.instance.collection("Section");
    userspref.add({
      "name": title.text,
      "image":url.toString()
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (file==null)?
            Container(
              height: MediaQuery.of(context).size.height/6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,


                  ),
              child: IconButton(onPressed: (){
                showDialog(context: context, builder: (
                    BuildContext context) {
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
              }, icon: Icon(Icons.add)),

              ):
           InkWell(child:Container(
             height: MediaQuery.of(context).size.height/6,
             decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 image: DecorationImage(
                     fit: BoxFit.fill,
                     image:FileImage(file!)
                 )

             ),) ,
           onTap: (){
             showDialog(context: context, builder: (
                 BuildContext context) {
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
            ,    Padding(padding: EdgeInsets.only(top: 10)),
            TextFormField(
              controller: title,
              textCapitalization: TextCapitalization.words,


              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.pages_outlined),
                  labelText:'Title',

                  labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
              ),
            ) ,
            Padding(padding: EdgeInsets.only(top: 50)),
            (isLoading==false) ?
            ElevatedButton(onPressed: () async {
      setState((){
        isLoading=true;
      });
      var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
      await addData();
      setState((){
        isLoading=false;
      });
     Navigator.pop(context);

    }, child:Text("add")):
            Center(child:CircularProgressIndicator()),


          ]),


    );
  }

}
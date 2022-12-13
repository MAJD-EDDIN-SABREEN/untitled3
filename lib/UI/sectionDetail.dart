import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class SectionDetail extends StatefulWidget{
  String id;
  String image;
  String title;

  SectionDetail(this.id, this.image, this.title);

  @override
  State<StatefulWidget> createState() {
    return SectionDetailState(this.id, this.image, this.title);
  }

}
class SectionDetailState extends State<SectionDetail>{
  String id;
  String image;
  String title;

  SectionDetailState(this.id, this.image, this.title);
  bool isLoading = false;
  File ?file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  TextEditingController title1=new TextEditingController();
  updateData(var id) async {
    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.update(userspref, {
          "name": title,
          "image":url.toString()

        });
      }
      else {
        print("no");
      }
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
  deleteData(var id) async {
    var userspref = FirebaseFirestore.instance
        .collection("Section");
    userspref.doc(id).delete();
  }
  @override
  void initState() {
title1.text=title;  }
  @override
  Widget build(BuildContext context) {
return
  Scaffold(
  body: Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (file==null)?
            InkWell(child:  Container(
              height: MediaQuery.of(context).size.height/6,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:NetworkImage(image)
                  )
              ),


            ),
            onTap:(){  showDialog(context: context, builder: (
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
            });} ,)

            :
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
          controller: title1,
          textCapitalization: TextCapitalization.words,


          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.pages_outlined),
              labelText:'Title',

              labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
          ),
        ) ,
    Padding(padding: EdgeInsets.only(top: 50))
    ,Row(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (isLoading==false) ?
        ElevatedButton(onPressed: () async {
          setState((){
            isLoading=true;
          });
          var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
          if(file!=null)
          {
            await refStorage.putFile(file!);
            url = await refStorage.getDownloadURL();
          }
          else{
            url=image;
          }
          await updateData(id);
          setState((){
            isLoading=false;
          });
          Navigator.pop(context);}, child:Text("Update")):
        Center(child:CircularProgressIndicator()),
        Padding(padding: EdgeInsets.only(left: 5)),
        (isLoading==false) ?  ElevatedButton(onPressed: () async {
          setState((){
            isLoading=true;
          });
          await deleteData(id);
          setState((){
            isLoading=false;
          });
          Navigator.pop(context);}, child:Text("Delete")):
        Center(child:CircularProgressIndicator())
      ],
    )

  ]),


);
  }

}
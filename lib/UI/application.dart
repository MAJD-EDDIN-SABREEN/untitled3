import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Application extends StatefulWidget {
  String sectionId;
   String jobId;
  Application(this.sectionId,this.jobId);

  @override
  State<Application> createState() => _ApplicationState(this.sectionId,this.jobId);
}

class _ApplicationState extends State<Application>  {
  String sectionId;
  String jobId;
  String id='';
   bool applied=false;
  _ApplicationState(this.sectionId, this.jobId);
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  TextEditingController expactSalary=new TextEditingController();
  TextEditingController notes=new TextEditingController();
  getapplied()async{
    final prefs = await SharedPreferences.getInstance();
     id= (await prefs.getString("id"))!;
     setState(() {

     });
     try{var userPref=await FirebaseFirestore.instance.collection("Application");
     var query=await userPref.where("userid",isEqualTo:id.toString()).where("jobid",isEqualTo: jobId).get();
     if(query.docs[0]==null){
       applied=false;
     }
     else{
       setState(() {
         applied=true;
       });
     }
     }
     catch(e){
       applied=false;
     }


  }
  addAppli() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    final prefs = await SharedPreferences.getInstance();
    String? id1= await prefs.getString("id");
    setState(() {
    id=id1.toString();
    });
    var userspref = await FirebaseFirestore.instance.collection("Application");
    userspref.add({
      "expected salary": expactSalary.text,
      "notes":notes.text,
      "Start_at":"${selectedDate.year}"+"-"+"${selectedDate.month}"+"-"+"${selectedDate.day}",
      "userid":id,
      "status":"0",
      "created_at":date.toString()
      ,"jobid":jobId
    });
  }
  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
      lastDate: DateTime(DateTime.now().year,DateTime.now().month+1,DateTime.now().day),

    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
@override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    getapplied();
    return  Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            TextFormField(
              controller: expactSalary,
              textCapitalization: TextCapitalization.words,

keyboardType: TextInputType.number,
              decoration: const InputDecoration(

                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.monetization_on_outlined),
                  labelText:'Expacted Salary',

                  labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
              ),
            ) ,

            TextFormField(
              controller: notes,
              textCapitalization: TextCapitalization.words,


              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.padding),
                  labelText:'notes',

                  labelStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold)
              ),
            ) ,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: Colors.black54,
                ),
                Text(
                    "date",
                    style: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Text(
                  '${selectedDate.year}' +
                      '/' +
                      '${selectedDate.month}' +
                      '/' +
                      '${selectedDate.day}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue)),
                  child: Text(
                    "selectDate",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    _selectedDate(context);
                  },
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            (applied==false)?
            ElevatedButton(onPressed: () async {
              setState((){
                isLoading=true;
              });
            
              await addAppli();
              setState((){
                isLoading=false;
              });
              Navigator.pop(context);

            }, child:Text("add")):
            Text("you applied alredy"),


          ]),

    );;
  }
}

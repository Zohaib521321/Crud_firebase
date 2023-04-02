import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class firestore_data extends StatefulWidget {
  const firestore_data({Key? key}) : super(key: key);

  @override
  State<firestore_data> createState() => _firestore_dataState();
}

class _firestore_dataState extends State<firestore_data> {

  final coll=FirebaseFirestore.instance.collection("user2");


  final editcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         StreamBuilder(
             stream:FirebaseFirestore.instance.collection("user1").snapshots()
            , builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
               if (!snapshot.hasData) {
                 return Text("Loading......");
               }
            else{
             return Expanded(child: ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context,index){
                   return ListTile(
                     leading: CircleAvatar(
                       backgroundImage: NetworkImage(snapshot.data!.docs[index]["url"].toString()),
                     ),
                     title: Text(snapshot.data!.docs[index]["Userspost"].toString()),

                     subtitle:Text(snapshot.data!.docs[index]["id"].toString()),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    tooltip: "More",
                    itemBuilder: (context)=>[
PopupMenuItem(
value: 1
    ,child:ListTile(
onTap: (){
  showdialogue1(snapshot.data!.docs[index]["Userspost"].toString(),snapshot.data!.docs[index].id.toString());


  }
,leading: Icon(Icons.edit),
  title: Text("Edit"),
    )),
                      PopupMenuItem(
                          value: 1
                          ,child:ListTile(
                        onTap: (){
                          Navigator.pop(context);
coll.doc(snapshot.data!.docs[index]["id"].toString()).delete();
                        }
                        ,leading: Icon(Icons.delete),
                        title: Text("Delete"),
                      )),
    ],

                  )
                   
                   );

                 }),);

               }
         }
    )
        ],
      ),
    );
  }
  Future<void> showdialogue1(String userpost ,String id)async{
  editcontroller.text=userpost;
    return showDialog(context: context, builder:(BuildContext Context){
return AlertDialog(
title: Text("Post"),
  content: Container(
    child: TextFormField(

      controller: editcontroller,
      decoration: InputDecoration(
        hintText: "Edit text",

      ),

    ),
  ),
actions: [
  TextButton(onPressed: (){
    Navigator.pop(context);
  }, child: Text("Cancel")),
TextButton(onPressed: (){

  Navigator.pop(context);
coll.doc(id).update({
  "Userspost":editcontroller.text.toString()
}).then((value) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Updated",style: TextStyle(color: Colors.redAccent),
    ),duration: Duration(seconds: 5),
  ));
}).onError((error, stackTrace) {
  print("error");
});
  }, child: Text("Update"))
],
);
    });
  }
}

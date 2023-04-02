import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
var url;
class Image_picker extends StatefulWidget {
  const Image_picker({Key? key}) : super(key: key);

  @override
  State<Image_picker> createState() => _Image_pickerState();
}

class _Image_pickerState extends State<Image_picker> {
  bool loading=false;
File? image;

final picker=ImagePicker();
storage.FirebaseStorage upload=storage.FirebaseStorage.instance;
final reference=FirebaseFirestore.instance.collection("user1") ;
Future getImagePicker()async{
final  imageFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
setState(() {
  if (imageFile!=null) {
    image=File(imageFile.path);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$image",style: TextStyle(color: Colors.redAccent),
      ),duration: Duration(seconds: 5),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Please pick image to further process",style: TextStyle(color: Colors.redAccent),
      ),duration: Duration(seconds: 5),
    ));
  }
});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           InkWell(
             onTap: (){
               getImagePicker();
             },
             child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent,width: 2)
                  ),
  child:image!=null?Image.file(image!.absolute):
                  Center(child: Icon(   Icons.image,size: 150,))),
           ),
            ElevatedButton(child:loading?CircularProgressIndicator() : Text("Upload image"),onPressed: ()async{
setState(() {
  loading=true;
});
final id=DateTime.now().microsecondsSinceEpoch.toString();
              storage.Reference ref=storage.FirebaseStorage.instance.ref("/images"+id);
storage.UploadTask uploadtask=ref.putFile(image!.absolute);
await Future.value(uploadtask);
 url=await ref.getDownloadURL();

reference.doc(id).set({

  "url":url.toString(),
}).then((value) =>{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Post added",style: TextStyle(color: Colors.redAccent),
    ),duration: Duration(seconds: 5),
    )),
    setState(() {
    loading = false;
    })


}).onError((error, stackTrace) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${error.toString()}",style: TextStyle(color: Colors.red))
              )),
              setState(() {
              loading = false;
              })
});
            }, ),

          ],
        ),
      ),
    );
  }
}

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/CRUD/data.dart';
import 'package:firebase/CRUD_firestore/Firestore_data.dart';
import 'package:firebase/CRUD_firestore/image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
var id=DateTime.now().microsecondsSinceEpoch.toString();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyBnOnQmEaG2sK0pzoTJt_eJyIIl-jyEMb0",
          appId: "1:1057246294895:web:ce0cf51f0669959fe82e9a",
          messagingSenderId: "1057246294895",
          projectId: "flutterfire-9d608",
        storageBucket: "flutterfire-9d608.appspot.com",
        databaseURL: "https://flutterfire-9d608-default-rtdb.firebaseio.com",
          measurementId: "G-152CRVZ7BS",

      )
    );
  }else{
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading=false;
  final postcontroller=TextEditingController();
  final ref=FirebaseFirestore.instance.collection("user1");


  File? _image;
final picker=ImagePicker();
Future imagePicker() async{
final pick=await picker.pickImage(source: ImageSource.gallery);
setState(() {
  if ( pick!=null) {
    _image=File(pick.path);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(" $_image",style: TextStyle(color: Colors.redAccent),
      ),duration: Duration(seconds: 4),
    ));
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("No image selected",style: TextStyle(color: Colors.redAccent),
      ),duration: Duration(seconds: 7),
    ));
  }
});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("fluutter container"),

      ),

      body:
Column(
children: [
  Padding(
    padding: const EdgeInsets.all(13.0),
    child: TextFormField(
      controller: postcontroller,
      maxLines: 4,
      decoration: InputDecoration(
          hintText: "What's on your mind",
          border: OutlineInputBorder(

          )
      ),

    ),

  ),
  SizedBox(
    height: 19,
  ),
Container(
  width: 300,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.purple.shade300)
    ),
    child:_image!=null?Image.file(_image!.absolute,height: 100,width: 300,fit: BoxFit.cover,):
    Center(child:Text("No image selected"))
 ),
  ElevatedButton(onPressed: ()async{
await imagePicker();

  },

      child: Text("Select image")),

  ElevatedButton(child:loading
      ? CircularProgressIndicator(): Text("Add Post"),
    onPressed: ()async{
      setState(() {
        loading=true;
      });

      storage.Reference refe=storage.FirebaseStorage.instance.ref("/images"+id);
      storage.UploadTask uploadtask=refe.putFile(_image!.absolute);
      await Future.value(uploadtask);
      url=await refe.getDownloadURL();

      ref.doc(id).set({"Userspost":postcontroller.text.toString(),"id":id,"url":url}).then((value){  ///1 is coloumn name userpost are the value which store
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Post added",style: TextStyle(color: Colors.redAccent),
          ),duration: Duration(seconds: 5),
        ));
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${error.toString()}",style: TextStyle(color: Colors.red))
        ));
        setState(() {
          loading = false;
        });
      });

    }, ),
  SizedBox(height: 19,),
  ElevatedButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>Image_picker()));
  }, child: Text("Image_picker"))
],
),


      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add,),
      onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>firestore_data()));
      },
    ),
    );
  }

}
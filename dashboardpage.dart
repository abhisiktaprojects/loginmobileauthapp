import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'authservice.dart';

class DashboardPage extends StatefulWidget {
  @override
  _PhotoPreviewScreenState createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<DashboardPage> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment:MainAxisAlignment.end,crossAxisAlignment:CrossAxisAlignment.end,children:[Center(
                child: Padding(padding:EdgeInsets.only(top: 44),child:MaterialButton(color: Colors.blue,
                  elevation: 4,
                  child: Text('Logout'),
                  onPressed: () {
                    AuthService().signOut();
                  },
                )
            ),), ]),
            Stack(children:[Column(children:[Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: imageFile == null  //profilePhoto which is File object
                      ? AssetImage(
                      "images/profile.png")
                      : FileImage(imageFile), // picked file
                  fit: BoxFit.fill)),
        ), ]),           Padding(padding: EdgeInsets.only(top:58,left:58),child:IconButton(icon: Icon(Icons.camera_alt),onPressed: (){_showSelectionDialog(context);},),),
            ]),
            Container(
              padding: EdgeInsets.all(22),
              child: Column(
                children: <Widget>[
                  Row(children:[ Text("Add new Employee Details", style:TextStyle(color:Colors.black, fontSize: 18, fontWeight: FontWeight.bold))]),

                  TextFormField( decoration: InputDecoration(contentPadding:EdgeInsets.only(bottom: -18),
                      hintText: 'Name'
                  ),

                  ),
                  TextFormField( decoration: InputDecoration(contentPadding:EdgeInsets.only(bottom: -18),
                      hintText: 'Mobile Number'
                  ),
                  ),
                  TextFormField( decoration: InputDecoration(contentPadding:EdgeInsets.only(bottom: -18),
                      hintText: 'Email Address'
                  ),
                  ),




                  ],
              ),
            ),

          ],
      ),
    );
  }

  // Widget _setImageView() {
  //   // if (imageFile != null) {
  //   //   return GestureDetector(
  //       // onTap: () => onProfileClick(context), // choose image on click of profile
  //       // child:
  //
  //   // } else {
  //   //   return Row(mainAxisAlignment:MainAxisAlignment.center,children:[IconButton(icon: Icon(Icons.account_circle_rounded, size: 100,),)]);
  //   // }
  // }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }
  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }
  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }}

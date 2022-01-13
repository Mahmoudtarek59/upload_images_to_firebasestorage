import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  XFile? image;
  String? url;

  uploadImage() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child("img${DateTime.now()}");
    var uploadTask = await ref.putFile(File(image!.path));
    url = await uploadTask.ref.getDownloadURL();
    setState(() {});
  }

  imagePicker() async {
    image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null)
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: FileImage(File(image!.path)))),
              ),
            ElevatedButton(onPressed: imagePicker, child: Text("PickImage")),
            if (url != null)
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: NetworkImage(url.toString()))),
              ),
            if (image != null)
              ElevatedButton(
                  onPressed: uploadImage, child: Text("UploadImage")),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registrationpage/Models/status_model.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:provider/provider.dart';

class UploadStatus extends StatefulWidget {
  const UploadStatus({super.key});

  @override
  State<UploadStatus> createState() => _UploadStatusState();
}

class _UploadStatusState extends State<UploadStatus> {
  XFile? _imagefile;
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _messageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Status",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Choose image from gallery"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleEditingController,
              decoration: InputDecoration(
                  hintText: "Enter title",
                  labelText: "Title",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageEditingController,
              minLines: 3,
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: "Enter message",
                  labelText: "Message",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_imagefile != null) {
                  uploadStatus();
                } else {
                  print("No image selected to upload");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Upload status"),
            ),
            const SizedBox(height: 20),
            _imagefile != null
                ? Image.file(
                    File(_imagefile!.path),
                    height: 150,
                  )
                : Text("No image selected"),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    var file = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagefile = file;
    });
  }

  Future<void> uploadStatus() async {
    if (_imagefile == null) {
      print("No image selected");
      return;
    }
    print("Enteres upload status");
    String? imageUrl = await uploadImage(File(_imagefile!.path));

    if (imageUrl != null) {
      try {
        StatusModel statusModel = StatusModel(
          imageurl: imageUrl,
          title: _titleEditingController.text,
          message: _messageEditingController.text,
        );
        print("Enter into upload status if condition");

        DocumentReference docRef = await FirebaseFirestore.instance
            .collection("statuses")
            .add(statusModel.toMap());

        statusModel.docid = docRef.id;
        print("Status uploaded with ID: ${statusModel.docid}");

        Fluttertoast.showToast(
          msg: "Status uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      } catch (e) {
        print("Failed to upload status to Firestore: $e");
        Fluttertoast.showToast(
          msg: "Failed to upload status",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      print("Image upload failed");
      Fluttertoast.showToast(
        msg: "Image upload failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("Swamy images/${DateTime.now().toIso8601String()}");

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }
}

// camera_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class CameraProvider with ChangeNotifier {
  File? _image;
  String _fileName = '';
  final ImagePicker _picker = ImagePicker();

  File? get image => _image;
  String get fileName => _fileName;

  Future<void> requestPermissions() async {
    await Permission.photos.request();
    await Permission.camera.request();
  }

  Future<void> getImage() async {
    await requestPermissions();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _fileName = pickedFile.name;
        notifyListeners();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "No image to upload", toastLength: Toast.LENGTH_SHORT);
      return;
    }

    try {
      // Replace with your upload API endpoint
      var uri = Uri.parse('https://your-api-endpoint.com/upload');

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Image Uploaded Successfully",
            toastLength: Toast.LENGTH_SHORT);
      } else {
        Fluttertoast.showToast(
            msg: "Failed to Upload Image", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: "Error Uploading Image", toastLength: Toast.LENGTH_SHORT);
    }
  }
}

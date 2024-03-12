import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/*
* Author：Johnny
* Description：This function is used to get the image from the camera or gallery, which is used in the profile page
* for update the avatar
*/

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

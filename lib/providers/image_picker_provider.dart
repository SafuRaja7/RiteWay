import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  XFile? _file;

  XFile? get file => _file;

  void pickImage() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );

    _file = image;

    notifyListeners();
  }

  void reset() {
    _file = null;

    notifyListeners();
  }
}

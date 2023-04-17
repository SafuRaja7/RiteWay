import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riteway/models/profile.dart';

class ProfileDataProvider {
  static final firebaseDocument =
      FirebaseFirestore.instance.collection('profile');

  static Future<ProfileModel> fetch() async {
    try {
      final doc = await firebaseDocument
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      final url = doc.get('url') as String?;
      final cnic = doc.get('cnic') as String?;
      final vehicleNumber = doc.get('vehicleNumber') as String?;

      return ProfileModel(
        url: url,
        cnic: cnic,
        vehicleNumber: vehicleNumber,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<ProfileModel> add(XFile? image, ProfileModel? prof) async {
    try {
      String url = await uploadImage(image!);
      await firebaseDocument.doc(FirebaseAuth.instance.currentUser!.uid).set(
        {
          'url': url,
          'cnic': prof!.cnic,
          'vehicleNumber': prof.vehicleNumber,
        },
      );
      ProfileModel profile = ProfileModel(url: url);
      return profile;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> uploadImage(XFile? file) async {
    try {
      String link = '';
      String fileanme = DateTime.now().millisecondsSinceEpoch.toString();
      if (file != null) {
        Reference ref = FirebaseStorage.instance.ref();
        Reference myRef = ref.child('profile');
        Reference finalImg = myRef.child(fileanme);

        await finalImg.putFile(File(file.path));

        link = await finalImg.getDownloadURL();
      }

      return link;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

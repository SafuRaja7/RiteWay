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
      if (doc.exists) {
        final url = doc.data()!['url'];
        final profile = ProfileModel(url: url);
        return profile;
      } else {
        throw Exception("Document does not exist");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<ProfileModel> add(XFile? image) async {
    try {
      String url = await uploadImage(image);
      await firebaseDocument.doc(FirebaseAuth.instance.currentUser!.uid).set(
        {'url': url},
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
      if (file != null) {
        Reference ref = FirebaseStorage.instance
            .ref('/profile/${file.path.split('/').last}')
            .child(file.path);

        await ref.putFile(File(file.path));

        String url = await ref.getDownloadURL();
        link = url;
      }

      return link;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

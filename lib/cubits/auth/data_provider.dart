part of 'cubit.dart';

class AuthDataProvider {
  static final firebaseFirestore = FirebaseFirestore.instance;
  static final userCollection = firebaseFirestore.collection('users_prod');

  static Future<AuthData> fetch() async {
    try {
      final data = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      final Map<String, dynamic>? raw = data.data();
      final authData = AuthData.fromMap(raw!);

      return authData;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<AuthData> login(String email, String password) async {
    try {
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user!;

      final data = await userCollection.doc(user.uid).get();
      final authData = AuthData.fromMap(data.data()!);

      return authData;
    } on FirebaseAuthException catch (e) {
      final err = e.toString();
      throw Exception(err);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<AuthData> signUp(
    String fullName,
    String email,
    String password,
    String type,
    String age,
    String gender,
    String? cnic,
    String? vehicleUrl,
    String? url,
  ) async {
    try {
      User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      final authData = AuthData.fromMap({
        'id': user.uid,
        'fullName': fullName,
        'email': email,
        'type': type,
        'age': age,
        'gender': gender,
        'url': url,
        'cnic': cnic,
        'vehicleUrl': vehicleUrl,
      });

      await user.updateDisplayName(fullName);

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      await userCollection.doc(user.uid).set(authData.toMap());

      if (kDebugMode) {
        firebaseFirestore
            .collection('users_prod')
            .doc(user.uid)
            .set(authData.toMap());
      }

      return authData;
    } on FirebaseAuthException catch (e) {
      final err = e.toString();
      throw Exception(err);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<void> updateAuth(AuthData authData, int index) async {
    try {
      final raw = await userCollection.doc(authData.id).get();
      List data = raw.data()!['users_prod'];

      data.removeAt(index);

      data.insert(
        index,
        authData.toMap(),
      );

      await userCollection.doc(authData.id).set(
        {'users_prod': data},
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> uploadImage(XFile? file) async {
    try {
      String link = '';
      if (file != null) {
        Reference ref =
            FirebaseStorage.instance.ref('user_prod').child(file.path);

        await ref.putFile(File(file.path));

        String url = await ref.getDownloadURL();
        link = url;
      }

      return link;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<AuthData>> addImage(
      XFile? image, AuthData authData) async {
    try {
      final raw = await userCollection.doc(authData.id).get();
      Map<String, dynamic> data = raw.data() ?? {};

      String url = await uploadImage(image);

      List images = data['images'] ?? [];
      images.add({
        'url': url,
      });

      await userCollection.doc(authData.id).set({
        'images': images,
      });

      List<AuthData> imgs = List.generate(
        images.length,
        (i) => AuthData.fromMap(
          images[i],
        ),
      );

      return imgs;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

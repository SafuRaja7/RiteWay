part of 'cubit.dart';

class AuthDataProvider {
  static final firebaseFirestore = FirebaseFirestore.instance;
  static final userCollection = firebaseFirestore.collection('users');

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
}

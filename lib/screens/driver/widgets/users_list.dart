import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/models/auth_data.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersList> {
  List<AuthData> authData = [];
  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    try {
      final users = await getAllUsers();
      setState(() {
        authData = users;
      });
    } catch (e) {
      Text('Error: $e');
    }
  }

  Future<List<AuthData>> getAllUsers() async {
    final users = <AuthData>[];
    final snapshot =
        await FirebaseFirestore.instance.collection('users_prod').get();

    for (var doc in snapshot.docs) {
      final user = AuthData.fromMap(doc.data());
      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Users',
          style: AppText.b1!.cl(Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Space.y1!,
            authData.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: authData.length,
                    itemBuilder: (context, index) {
                      final user = authData[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.flutter_dash,
                              ),
                            ),
                            title: Text(user.fullName!),
                            subtitle: Text(user.email),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}

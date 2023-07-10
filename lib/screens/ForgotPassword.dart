import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riteway/screens/login/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var email = '';
  final emailcontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password Reset Email has been sent",
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found for that email");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No user found for that email",
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30, top: 140),
            child: const Text(
              'Forgot\nPassword',
              style: TextStyle(
                  fontSize: 33,
                  fontFamily: "bold",
                  fontStyle: FontStyle.italic),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailcontroller,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Email",
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter email';
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return 'Please a valid Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Send email',
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xff4c505b),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_formkey.currentState?.validate() ??
                                          false) {
                                        setState(() {
                                          email = emailcontroller.text;
                                        });
                                        resetPassword();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    resetPassword();
                                  },
                                  style: const ButtonStyle(),
                                  child: const Text(
                                    'Resend email',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return const Login();
                                        },
                                      ));
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18,
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

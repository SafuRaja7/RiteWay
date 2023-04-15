import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/widgets/app_button.dart';
import 'package:riteway/widgets/custom_text_field.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool editProfile = false;

  @override
  void initState() {
    super.initState();
    final authCubit = AuthCubit.cubit(context);
    authCubit.fetch();
  }

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    App.init(context);
    final authCubit = AuthCubit.cubit(context, true);
    final authData = authCubit.state.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Space.all(1),
          physics: const AlwaysScrollableScrollPhysics(),
          child: FormBuilder(
            key: _formKey,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthFetchLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.c!.primary!,
                    ),
                  );
                } else if (state is AuthFetchSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profile',
                            style: AppText.h1b,
                          ),
                        ],
                      ),
                      Space.y1!,
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: AppDimensions.normalize(20),
                            backgroundColor:
                                AppTheme.c!.primary!.withAlpha(100),
                            // child: FadeInImage(
                            //   placeholder: const AssetImage(
                            //     'assets/applogo.png',
                            //   ),
                            //   image: NetworkImage(authData!.url!),
                            // )
                          ),
                          Positioned(
                            right: 0.5,
                            bottom: 0.5,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        padding: Space.all(0.5),
                                        height: AppDimensions.normalize(100),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child:
                                                      const Icon(Icons.close),
                                                )
                                              ],
                                            ),
                                            Space.y1!,
                                            IconButton(
                                              onPressed: () async {
                                                ImagePicker imagePicker =
                                                    ImagePicker();
                                                XFile? file =
                                                    await imagePicker.pickImage(
                                                  source: ImageSource.gallery,
                                                );

                                                if (file == null) return;
                                                String uniqueFileName =
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();

                                                Reference referenceRoot =
                                                    FirebaseStorage.instance
                                                        .ref();
                                                Reference referenceDirImages =
                                                    referenceRoot
                                                        .child('user_prod');

                                                Reference
                                                    referenceImageToUpload =
                                                    referenceDirImages
                                                        .child(uniqueFileName);

                                                try {
                                                  await referenceImageToUpload
                                                      .putFile(File(file.path));
                                                  imageUrl =
                                                      await referenceImageToUpload
                                                          .getDownloadURL();
                                                } catch (error) {
                                                  throw Exception(
                                                    error.toString(),
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Space.y2!,
                                            InkWell(
                                              onTap: () async {
                                                await updateImageUrl(
                                                  user!.uid,
                                                  imageUrl,
                                                );
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                height:
                                                    AppDimensions.normalize(17),
                                                width:
                                                    AppDimensions.normalize(70),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.c!.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: const Center(
                                                  child: Text("Upload Image"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.c!.primary!.withAlpha(200),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Space.y1!,
                      Text(
                        authData!.fullName,
                        style: AppText.h2,
                      ),
                      Text(
                        authData.email,
                        style: AppText.b2!.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Space.yf(3),
                      Row(
                        children: [
                          Text(
                            'Name',
                            style: AppText.b1b,
                          ),
                          Space.x1!,
                          Expanded(
                            child: CustomTextField(
                              initialValue: authData.fullName,
                              name: 'fullName',
                              hint: 'Name',
                              textInputType: TextInputType.text,
                              enabled: editProfile,
                              validatorFtn: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Name is required',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Space.y1!,
                      Row(
                        children: [
                          Text(
                            'Email',
                            style: AppText.b1b,
                          ),
                          Space.x1!,
                          Expanded(
                            child: CustomTextField(
                              initialValue: authData.email,
                              name: 'email',
                              hint: 'Email',
                              textInputType: TextInputType.text,
                              enabled: editProfile,
                              validatorFtn: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Email is required',
                                ),
                                FormBuilderValidators.email(
                                  errorText: 'Email format is invalid',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Space.y1!,
                      Row(
                        children: [
                          Text(
                            'Age   ',
                            style: AppText.b1b,
                          ),
                          Space.x1!,
                          Expanded(
                            child: CustomTextField(
                              initialValue: authData.age,
                              name: 'age',
                              hint: 'Age',
                              textInputType: TextInputType.text,
                              enabled: editProfile,
                              validatorFtn: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Age is required',
                                ),
                                FormBuilderValidators.numeric(
                                  errorText:
                                      'Only numeric values shoy=uld be accepted',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Space.y1!,
                      Row(
                        children: [
                          Text(
                            'Gender',
                            style: AppText.b1b,
                          ),
                          Space.x!,
                          Expanded(
                            child: CustomTextField(
                              initialValue: authData.gender,
                              name: 'gender',
                              hint: 'Gender',
                              textInputType: TextInputType.text,
                              enabled: editProfile,
                              validatorFtn: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Gender is required',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Space.y1!,
                      Row(
                        children: [
                          Text(
                            'Type  ',
                            style: AppText.b1b,
                          ),
                          Space.x1!,
                          Expanded(
                            child: CustomTextField(
                              initialValue: authData.type,
                              name: 'type',
                              hint: 'Type',
                              textInputType: TextInputType.text,
                              enabled: editProfile,
                              validatorFtn: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Type is required',
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Space.y1!,
                      AppButton(
                        child: Text(
                          editProfile ? 'Save' : 'Edit Profile',
                        ),
                        onPressed: () {
                          setState(
                            () {
                              final isValid =
                                  _formKey.currentState!.saveAndValidate();
                              if (!isValid) return;

                              final form = _formKey.currentState!;
                              final data = form.value;

                              FocusScope.of(context).unfocus();

                              final authData = authCubit.state.data;
                              final documentReference = FirebaseFirestore
                                  .instance
                                  .collection('users_prod')
                                  .doc(authData!.id);
                              if (!editProfile) {
                                editProfile = !editProfile;
                              } else {
                                documentReference.update(data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile updated.'),
                                  ),
                                );
                                editProfile = !editProfile;
                              }
                            },
                          );
                        },
                      ),
                      Space.y2!,
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'App version',
                                style: AppText.l1b!.cl(
                                  AppTheme.c!.text!,
                                ),
                              ),
                              TextSpan(
                                text: " Version 1.0",
                                style: AppText.l1b!.cl(
                                  AppTheme.c!.primary!,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Space.y1!,
                    ],
                  );
                }
                throw Exception('Failed');
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateImageUrl(String userId, String imageUrl) async {
    final usersProdRef = FirebaseFirestore.instance.collection('users_prod');
    final docRef = usersProdRef.doc(userId);

    try {
      await docRef.update({
        'url': imageUrl,
      });
    } catch (error) {
      rethrow;
    }
  }
}

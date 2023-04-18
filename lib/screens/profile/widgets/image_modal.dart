// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/cubits/profile/profile_cubit.dart';
import 'package:riteway/providers/image_picker_provider.dart';
import 'package:riteway/widgets/app_button.dart';

class ImageModal extends StatelessWidget {
  final bool license;
  const ImageModal({
    Key? key,
    required this.license,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.cubit(context);
    App.init(context);
    final imgPicker = Provider.of<ImagePickerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Space.y1!,
            Text(
              'Choose Image to Upload',
              style: AppText.b1,
            ),
            Space.y1!,
            if (imgPicker.file != null)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: AppDimensions.normalize(
                      190,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(
                          File(imgPicker.file!.path),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => imgPicker.reset(),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            if (imgPicker.file == null)
              InkWell(
                onTap: () => imgPicker.pickImage(),
                child: Container(
                  height: AppDimensions.normalize(
                    190,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: AppDimensions.normalize(25),
                    ),
                  ),
                ),
              ),
            BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileAddSuccess) {
                  imgPicker.reset();
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state is ProfileAddLoading) {
                  return const LinearProgressIndicator();
                }
                return const SizedBox();
              },
            ),
            Space.y2!,
            AppButton(
              width: AppDimensions.normalize(70),
              child: Text(
                'Add Image',
                style: AppText.b2b!.copyWith(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (imgPicker.file == null) {
                  return showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Error',
                          style: AppText.h2b!,
                        ),
                        content: const Text('Please choose an Image'),
                        actions: [
                          AppButton(
                            child: Text(
                              'Back',
                              style: AppText.b2b!.cl(Colors.white),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  final authData = authCubit.state.data;
                  final documentReference = FirebaseFirestore.instance
                      .collection('users_prod')
                      .doc(authData!.id);

                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('auth/${path.basename(imgPicker.file!.path)}');
                  final uploadTask =
                      storageRef.putFile(File(imgPicker.file!.path));

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(width: 20),
                              Text("Uploading image..."),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  final snapshot = await uploadTask.whenComplete(() {});

                  final downloadURL = await snapshot.ref.getDownloadURL();

                  !license
                      ? documentReference.update({'url': downloadURL})
                      : documentReference.update({'licenseUrl': downloadURL});

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

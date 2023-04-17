import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/profile/profile_cubit.dart';
import 'package:riteway/models/profile.dart';
import 'package:riteway/providers/image_picker_provider.dart';
import 'package:riteway/widgets/app_button.dart';

class ImageModal extends StatelessWidget {
  const ImageModal({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCubit = BlocProvider.of<ProfileCubit>(context);
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
              onPressed: () {
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
                  final profile = ProfileModel();
                  profileCubit.add(
                    imgPicker.file!,
                    profile,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

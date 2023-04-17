// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/app_dimensions.dart';
import 'package:riteway/configs/app_theme.dart';
import 'package:riteway/configs/app_typography.dart';
import 'package:riteway/configs/app_typography_ext.dart';
import 'package:riteway/configs/space.dart';
import 'package:riteway/cubits/profile/profile_cubit.dart';
import 'package:riteway/providers/image_picker_provider.dart';
import 'package:riteway/widgets/app_button.dart';
import 'package:riteway/widgets/custom_text_field.dart';

class DriverCredentials extends StatefulWidget {
  final bool? Function(bool?)? isNext;
  const DriverCredentials({
    Key? key,
    this.isNext,
  }) : super(key: key);

  @override
  State<DriverCredentials> createState() => _DriverCredentialsState();
}

class _DriverCredentialsState extends State<DriverCredentials> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final imgPicker = Provider.of<ImagePickerProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: Space.all(1),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Space.y1!,
              Center(
                child: Image.asset(
                  'assets/applogo.png',
                  height: AppDimensions.normalize(70),
                ),
              ),
              Space.y!,
              Text(
                'Please fill the following information',
                style: AppText.l1!.copyWith(
                  color: AppTheme.c!.text,
                ),
              ),
              Space.y1!,
              CustomTextField(
                name: 'cnic',
                hint: 'CNIC',
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                validatorFtn: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: 'Cnic is required',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Please add a valid CNIC number',
                    ),
                  ],
                ),
              ),
              Space.y!,
              CustomTextField(
                name: 'vehicleNumber',
                hint: 'Vehicle Number',
                textInputType: TextInputType.text,
                validatorFtn: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: 'Vehicle Number is required',
                    ),
                  ],
                ),
              ),
              Space.y!,
              CustomTextField(
                name: 'license',
                hint: 'License',
                textInputType: TextInputType.text,
                validatorFtn: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: 'License is required',
                    ),
                  ],
                ),
              ),
              Space.y1!,
              Text(
                "Image",
                style: AppText.b1,
              ),
              Column(
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
                      'Next',
                      style: AppText.b2b!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      final isValid = _formKey.currentState!.saveAndValidate();
                      if (!isValid) return null;
                      FocusScope.of(context).unfocus();

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
                        widget.isNext!(true);

                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:riteway/app_routes.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/cubits/profile/profile_cubit.dart';
import 'package:riteway/providers/image_picker_provider.dart';
import 'package:riteway/screens/profile/widgets/image_modal.dart';
import 'package:riteway/widgets/app_button.dart';
import 'package:riteway/widgets/custom_text_field.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imgUrl = '';
  final _formKey = GlobalKey<FormBuilderState>();
  bool editProfile = false;

  @override
  void initState() {
    super.initState();
    final authCubit = AuthCubit.cubit(context);
    final profileCubit = ProfileCubit.cubit(context);
    authCubit.fetch();
    profileCubit.fetch();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final authCubit = AuthCubit.cubit(context, true);
    final imgPicker = Provider.of<ImagePickerProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Space.all(1),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: AppText.h1b,
                  ),
                  IconButton(
                    onPressed: () {
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLogoutLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is AuthLogoutSuccess) {
                            authCubit.logout();
                          }
                          return const Center(
                            child: Text("Error occured"),
                          );
                        },
                      );

                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              Space.y1!,
              FormBuilder(
                key: _formKey,
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthFetchLoading) {
                      return const LinearProgressIndicator();
                    } else if (state is AuthFetchSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          state.data!.url != null && state.data!.url!.isNotEmpty
                              ? SizedBox(
                                  width: AppDimensions.normalize(50),
                                  height: AppDimensions.normalize(50),
                                  child: Material(
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      height: AppDimensions.normalize(50),
                                      imageUrl: state.data!.url!,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: AppDimensions.normalize(50),
                                  height: AppDimensions.normalize(50),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.c!.primary!.withAlpha(200),
                                  ),
                                  child: Center(
                                    child: Text(
                                      state.data!.fullName!
                                          .substring(0, 2)
                                          .toUpperCase(),
                                      style: AppText.b1!.cl(Colors.black),
                                    ),
                                  ),
                                ),
                          Space.y!,
                          AppButton(
                            width: AppDimensions.normalize(70),
                            child: Row(
                              children: [
                                Space.x2!,
                                const Icon(Icons.upload),
                                const Text('Upload Image'),
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                imgPicker.reset();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ImageModal(
                                        license: false,
                                      );
                                    },
                                  ),
                                );
                              });
                            },
                          ),
                          Space.y1!,
                          Text(
                            state.data!.fullName!,
                            style: AppText.h2,
                          ),
                          Text(
                            state.data!.email,
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
                                  initialValue: state.data!.fullName,
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
                          if (state.data!.type == 'Driver' ||
                              state.data!.type == 'Rider') ...[
                            Row(
                              children: [
                                Text(
                                  'Email',
                                  style: AppText.b1b,
                                ),
                                Space.x1!,
                                Expanded(
                                  child: CustomTextField(
                                    initialValue: state.data!.email,
                                    name: 'email',
                                    hint: 'Email',
                                    textInputType: TextInputType.text,
                                    enabled: editProfile,
                                    validatorFtn: FormBuilderValidators.compose(
                                      [
                                        FormBuilderValidators.required(
                                          errorText: 'Email is required',
                                        ),
                                        FormBuilderValidators.match(
                                          r'^[a-zA-Z0-9._%+-]+@cust\.pk$',
                                          errorText:
                                              'Invalid email format (email@cust.pk)',
                                        )
                                      ],
                                    ),
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
                                    initialValue: state.data!.age,
                                    name: 'age',
                                    hint: 'Age',
                                    textInputType: TextInputType.text,
                                    enabled: editProfile,
                                    validatorFtn:
                                        FormBuilderValidators.compose([
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
                                    initialValue: state.data!.gender,
                                    name: 'gender',
                                    hint: 'Gender',
                                    textInputType: TextInputType.text,
                                    enabled: editProfile,
                                    validatorFtn:
                                        FormBuilderValidators.compose([
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
                                    initialValue: state.data!.type,
                                    name: 'type',
                                    hint: 'Type',
                                    textInputType: TextInputType.text,
                                    enabled: editProfile,
                                    validatorFtn:
                                        FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: 'Type is required',
                                      ),
                                    ]),
                                  ),
                                ),
                                Space.x1!,
                              ],
                            ),
                          ],
                          if (state.data!.type == 'Driver' &&
                              state.data != null) ...[
                            Space.y!,
                            Row(
                              children: [
                                Text(
                                  'Vehicle No',
                                  style: AppText.b1b,
                                ),
                                Space.x1!,
                                Expanded(
                                  child: CustomTextField(
                                    initialValue: state.data!.vehicleNumber,
                                    name: 'vehicleNumber',
                                    hint: 'Vehicle Number',
                                    textInputType: TextInputType.text,
                                    enabled: editProfile,
                                    validatorFtn:
                                        FormBuilderValidators.required(
                                      errorText: 'Vehicle Number is required',
                                    ),
                                  ),
                                ),
                                Space.x1!,
                              ],
                            ),
                            Space.y!,
                            Row(
                              children: [
                                Text(
                                  'CNIC',
                                  style: AppText.b1b,
                                ),
                                Space.x1!,
                                Expanded(
                                  child: CustomTextField(
                                    initialValue: state.data!.cnic,
                                    name: 'cnic',
                                    hint: 'CNIC',
                                    textInputType: TextInputType.text,
                                    enabled: false,
                                    validatorFtn:
                                        FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: 'CNIC is required',
                                      ),
                                    ]),
                                  ),
                                ),
                                Space.x1!,
                              ],
                            ),
                            Space.y!,
                            Row(
                              children: [
                                Text(
                                  'License',
                                  style: AppText.b1b,
                                ),
                                Space.x1!,
                                Expanded(
                                  child: AppButton(
                                    child: const Text('Upload Image'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const ImageModal(
                                              license: true,
                                            );
                                          },
                                        ),
                                      );
                                      imgPicker.reset();
                                    },
                                  ),
                                ),
                                Space.x1!,
                              ],
                            ),
                          ],
                          Space.y1!,
                          AppButton(
                            child: Text(
                              editProfile ? 'Save' : 'Click to Edit',
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
            ],
          ),
        ),
      ),
    );
  }
}

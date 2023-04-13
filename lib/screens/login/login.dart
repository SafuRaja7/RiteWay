import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/screens/profile/profile.dart';
import 'package:riteway/screens/signup/signup.dart';
import 'package:riteway/widgets/app_button.dart';
import 'package:riteway/widgets/custom_snackbar.dart';
import 'package:riteway/widgets/custom_text_field.dart';
import 'package:riteway/widgets/screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _BodyState();
}

class _BodyState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final authCubit = AuthCubit.cubit(context);

    return Screen(
      overlayWidgets: [
        BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (a, b) => a != b,
          builder: (context, authState) {
            if (authState is AuthLoginLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const SizedBox();
          },
          listener: (context, authState) async {
            if (authState is AuthLoginFailed) {
              CustomSnackBars.failure(
                context,
                authState.message!,
                title: 'Error!',
              );
            } else if (authState is AuthLoginSuccess) {
              _formKey.currentState!.reset();
              if (authCubit.state.data!.type == 'Driver') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Profile();
                    },
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SignUp();
                    },
                  ),
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          padding: Space.all(1),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space.yf(5),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/applogo.png',
                    height: AppDimensions.normalize(30),
                  ),
                ),
                Space.y!,
                Text(
                  'Welcome to\nRiteWay',
                  style: AppText.h1b,
                ),
                Space.y!,
                Text(
                  'Please log in to your account',
                  style: AppText.b2!.copyWith(
                    color: AppTheme.c!.text,
                  ),
                ),
                Space.y2!,
                CustomTextField(
                  name: 'email',
                  hint: 'Email address',
                  textInputType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  validatorFtn: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Email is required',
                    ),
                    FormBuilderValidators.email(
                      errorText: 'Email format is invalid',
                    ),
                  ]),
                ),
                Space.y!,
                CustomTextField(
                  name: 'password',
                  hint: 'Password',
                  isPass: true,
                  textInputType: TextInputType.text,
                  validatorFtn: FormBuilderValidators.required(
                    errorText: 'Password is required',
                  ),
                ),
                Space.y1!,
                AppButton(
                  child: Text(
                    'Login',
                    style: AppText.b1!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      FocusScope.of(context).unfocus();
                      final form = _formKey.currentState!;
                      final data = form.value;

                      authCubit.login(
                        data['email'],
                        data['password'],
                      );
                    }
                  },
                ),
                Space.y!,
                Space.y1!,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: AppText.l1,
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: AppText.l1b,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:riteway/app_routes.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/screens/ForgotPassword.dart';
import 'package:riteway/screens/home/home.dart';
import 'package:riteway/widgets/app_button.dart';
import 'package:riteway/widgets/custom_snackbar.dart';
import 'package:riteway/widgets/custom_text_field.dart';
import 'package:riteway/widgets/form_data.dart';
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
    final authCubit = AuthCubit.cubit(context, true);

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

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Home();
                  },
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          padding: Space.all(1),
          child: FormBuilder(
            key: _formKey,
            initialValue: FormData.initalValues(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space.yf(5),
                Hero(
                  tag: 'logo',
                  child: Center(
                    child: Image.asset(
                      'assets/applogo.png',
                      height: AppDimensions.normalize(70),
                    ),
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
                      errorText: 'Provide a valid email',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPassword();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password',
                        style:
                            AppText.l1b!.copyWith(color: AppTheme.c!.primary),
                      ),
                    ),
                  ],
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
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.signup),
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

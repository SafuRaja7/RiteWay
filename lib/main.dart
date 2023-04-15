import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:riteway/app_routes.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/cubits/route_points/route_points_cubit.dart';
import 'package:riteway/cubits/routes/routes_cubit.dart';
import 'package:riteway/providers/image_picker_provider.dart';
import 'package:riteway/screens/driver/driver.dart';
import 'package:riteway/screens/driver/widgets/users_list.dart';
import 'package:riteway/screens/login/login.dart';
import 'package:riteway/screens/profile/profile.dart';
import 'package:riteway/screens/rider/rider.dart';
import 'package:riteway/screens/routes/routes_name.dart';
import 'package:riteway/screens/signup/signup.dart';
import 'package:riteway/screens/splash.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => RoutesCubit()),
        BlocProvider(create: (context) => RoutePointsCubit()),
        ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RiteWay',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => const Login(),
          AppRoutes.signup: (context) => const SignUp(),
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.driver: (context) => const Driver(),
          AppRoutes.rider: (context) => const Rider(),
          AppRoutes.profile: (context) => const Profile(),
          AppRoutes.routesNameScreen: (context) => const RoutesNameScreen(),
          AppRoutes.usersList: (context) => const UsersList(),
        },
      ),
    );
  }
}

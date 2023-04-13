import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riteway/models/auth_data.dart';

part 'data_provider.dart';
part 'state.dart';

class AuthCubit extends Cubit<AuthState> {
  static AuthCubit cubit(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<AuthCubit>(context, listen: listen);

  AuthCubit() : super(AuthDefault());

  Future<void> fetch() async {
    emit(const AuthFetchLoading());
    try {
      final data = await AuthDataProvider.fetch();

      emit(AuthFetchSuccess(data: data));
    } catch (e) {
      emit(AuthFetchFailed(message: e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoginLoading());
    try {
      final data = await AuthDataProvider.login(email, password);

      emit(AuthLoginSuccess(data: data));
    } catch (e) {
      emit(AuthLoginFailed(message: e.toString()));
    }
  }

  Future<void> signup(String fullName, String email, String password,
      String type, String age, String gender) async {
    emit(const AuthSignUpLoading());
    try {
      final data = await AuthDataProvider.signUp(
        fullName,
        email,
        password,
        type,
        age,
        gender,
      );

      emit(AuthSignUpSuccess(data: data));
    } catch (e) {
      emit(AuthSignUpFailed(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLogoutSuccess());
    try {
      await AuthDataProvider.logout();

      emit(const AuthLogoutSuccess());
    } catch (e) {
      emit(AuthLogoutFailed(message: e.toString()));
    }
  }
}
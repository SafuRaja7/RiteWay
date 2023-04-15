import 'package:flutter/foundation.dart';

class _FormKeys {
  static const email = 'email';
  static const password = 'password';
}

class FormData {
  static Map<String, dynamic> initalValues() {
    if (kDebugMode) {
      return {
        _FormKeys.email: 'riderMe@gmail.com',
        _FormKeys.password: '123456',
      };
    }

    return {};
  }
}

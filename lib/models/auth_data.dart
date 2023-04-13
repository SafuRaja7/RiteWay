// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthData {
  final String id;
  final String fullName;
  final String email;
  final String type;
  final String age;
  final String gender;
  final String? url;
  AuthData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.type,
    required this.age,
    required this.gender,
    this.url,
  });

  AuthData copyWith({
    String? id,
    String? fullName,
    String? email,
    String? type,
    String? age,
    String? gender,
    String? url,
  }) {
    return AuthData(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      type: type ?? this.type,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'type': type,
      'age': age,
      'gender': gender,
      'url': url,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      type: map['type'] as String,
      age: map['age'] as String,
      gender: map['gender'] as String,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthData(id: $id, fullName: $fullName, email: $email, type: $type, age: $age, gender: $gender, url: $url)';
  }

  @override
  bool operator ==(covariant AuthData other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.fullName == fullName &&
      other.email == email &&
      other.type == type &&
      other.age == age &&
      other.gender == gender &&
      other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      type.hashCode ^
      age.hashCode ^
      gender.hashCode ^
      url.hashCode;
  }
}

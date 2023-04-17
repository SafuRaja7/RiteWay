// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProfileModel {
  final String? url;
  final String? cnic;
  final String? vehicleNumber;
  ProfileModel({
    this.url,
    this.cnic,
    this.vehicleNumber,
  });

  ProfileModel copyWith({
    String? url,
    String? cnic,
    String? vehicleNumber,
  }) {
    return ProfileModel(
      url: url ?? this.url,
      cnic: cnic ?? this.cnic,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'cnic': cnic,
      'vehicleNumber': vehicleNumber,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      url: map['url'] != null ? map['url'] as String : '',
      cnic: map['cnic'] != null ? map['cnic'] as String : '',
      vehicleNumber:
          map['vehicleNumber'] != null ? map['vehicleNumber'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProfileModel(url: $url, cnic: $cnic, vehicleNumber: $vehicleNumber)';

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.cnic == cnic &&
        other.vehicleNumber == vehicleNumber;
  }

  @override
  int get hashCode => url.hashCode ^ cnic.hashCode ^ vehicleNumber.hashCode;
}

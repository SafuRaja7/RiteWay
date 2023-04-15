// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:riteway/models/routes_points.dart';

class Routes {
  final String? name;
  final String? createdAt;
  final RoutePoints? routePoints;
  Routes({
    required this.name,
    this.createdAt,
    this.routePoints,
  });

  Routes copyWith({
    String? name,
    String? createdAt,
    RoutePoints? routePoints,
  }) {
    return Routes(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      routePoints: routePoints ?? this.routePoints,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'createdAt': createdAt,
      'routePoints': routePoints?.toMap(),
    };
  }

  factory Routes.fromMap(Map<String, dynamic> map) {
    return Routes(
      name: map['name'] != null ? map['name'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      routePoints: map['routePoints'] != null ? RoutePoints.fromMap(map['routePoints'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Routes.fromJson(String source) =>
      Routes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Routes(name: $name, createdAt: $createdAt, routePoints: $routePoints)';

  @override
  bool operator ==(covariant Routes other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.createdAt == createdAt &&
      other.routePoints == routePoints;
  }

  @override
  int get hashCode => name.hashCode ^ createdAt.hashCode ^ routePoints.hashCode;
}

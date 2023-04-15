// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RoutePoints {
  final String? name;
  final int? fare;
  final String? routeId;
  final int? stop;
  RoutePoints({
    this.name,
    this.fare,
    this.routeId,
    this.stop,
  });

  RoutePoints copyWith({
    String? name,
    int? fare,
    String? routeId,
    int? stop,
  }) {
    return RoutePoints(
      name: name ?? this.name,
      fare: fare ?? this.fare,
      routeId: routeId ?? this.routeId,
      stop: stop ?? this.stop,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'fare': fare,
      'routeId': routeId,
      'stop': stop,
    };
  }

  factory RoutePoints.fromMap(Map<String, dynamic> map) {
    return RoutePoints(
      name: map['name'] != null ? map['name'] as String : null,
      fare: map['fare'] != null ? map['fare'] as int : null,
      routeId: map['routeId'] != null ? map['routeId'] as String : null,
      stop: map['stop'] != null ? map['stop'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoutePoints.fromJson(String source) => RoutePoints.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoutePoints(name: $name, fare: $fare, routeId: $routeId, stop: $stop)';
  }

  @override
  bool operator ==(covariant RoutePoints other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.fare == fare &&
      other.routeId == routeId &&
      other.stop == stop;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      fare.hashCode ^
      routeId.hashCode ^
      stop.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VehicleModel {
  final String yearsOld;
  final String mileage;
  final String bikeName;
  VehicleModel({
    required this.yearsOld,
    required this.mileage,
    required this.bikeName,
  });

  VehicleModel copyWith({
    String? yearsOld,
    String? mileage,
    String? pollutant,
    String? bikeName,
  }) {
    return VehicleModel(
      yearsOld: yearsOld ?? this.yearsOld,
      mileage: mileage ?? this.mileage,
      bikeName: bikeName ?? this.bikeName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'yearsOld': yearsOld,
      'mileage': mileage,
      'bikeName': bikeName,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      yearsOld: map['yearsOld'] as String,
      mileage: map['mileage'] as String,
      bikeName: map['bikeName'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory VehicleModel.fromJson(String source) => VehicleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VehicleModel(yearsOld: $yearsOld, mileage: $mileage, bikeName: $bikeName)';
  }

  @override
  bool operator ==(covariant VehicleModel other) {
    if (identical(this, other)) return true;

    return other.yearsOld == yearsOld &&
        other.mileage == mileage &&
        other.bikeName == bikeName;
  }

  @override
  int get hashCode {
    return yearsOld.hashCode ^
        mileage.hashCode ^
        bikeName.hashCode;
  }
}

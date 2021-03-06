import 'package:json_annotation/json_annotation.dart';
import 'package:token_system/Entities/abstract.dart';
part 'authority.g.dart';
@JsonSerializable()
class Authority extends Entity {
  int id;
  String name;
  String email;
  String mobileNumber;
  String aadhaarNumber;
  String state;
  String district;
  String pincode;
  int authVerification;

  Authority({
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.aadhaarNumber,
    this.state,
    this.district,
    this.pincode,
    this.authVerification,
  });

  Map<String, dynamic> registerToJson(String password) => {
        "name": this.name,
        "email": this.email,
        "password": password,
        "mobileNumber": this.mobileNumber,
        "aadhaarNumber": this.aadhaarNumber,
        "pincode": this.pincode,
      };

  Map<String, dynamic> updateToJson(
          {String name, String mobileNumber, String aadhaarNumber, String pincode}) =>
      {
        "id": this.id.toString(),
        "name": name ?? this.name,
        "mobileNumber": mobileNumber ?? this.mobileNumber,
        "aadhaarNumber": aadhaarNumber ?? this.aadhaarNumber,
        "pincode": pincode ?? this.pincode,
      };

  factory Authority.verifyFromJson(Map<String, dynamic> json, String email) {
    return Authority(
        id: json['id'] as int,
        name: json['name'] as String,
        email: email,
        mobileNumber: json['mobileNumber'] as String,
        aadhaarNumber: json['aadhaarNumber'] as String,
        state: json['state'] as String,
        district: json['district'] as String,
        pincode: json['pincode'] as String,
        authVerification: json['authVerification'] as int);
  }
  factory Authority.fromJson(Map<String, dynamic> json) => _$AuthorityFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorityToJson(this);
}


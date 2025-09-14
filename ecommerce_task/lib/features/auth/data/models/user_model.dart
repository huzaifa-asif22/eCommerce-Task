import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel extends User {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String email;

  @HiveField(2)
  @override
  final String name;

  @HiveField(3)
  @override
  final String? profileImage;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  }) : super(id: id, email: email, name: name, profileImage: profileImage);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

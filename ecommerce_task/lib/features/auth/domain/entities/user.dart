import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? profileImage;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, email, name, profileImage];
}

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

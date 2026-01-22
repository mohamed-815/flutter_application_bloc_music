import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

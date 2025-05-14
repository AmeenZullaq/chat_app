import 'package:chat_app/core/errors/error_model.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<ErrorModel, UserModel>> login({
    required String email,
    required String password,
  });
  Future<Either<ErrorModel, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
  });
}

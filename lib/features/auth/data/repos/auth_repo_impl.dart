import 'package:chat_app/core/errors/error_model.dart';
import 'package:chat_app/core/errors/firebase_error_handler.dart';
import 'package:chat_app/core/services/firebase_auth_service.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;

  AuthRepoImpl(this.firebaseAuthService);
  @override
  Future<Either<ErrorModel, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await firebaseAuthService.singInwithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel.fromAuthFirebase(userCred);
      return right(user);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel.fromAuthFirebase(userCred);
      return right(user);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }
}

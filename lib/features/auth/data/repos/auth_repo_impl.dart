import 'dart:convert';
import 'package:chat_app/core/constants/app_endpoints.dart';
import 'package:chat_app/core/constants/app_keys.dart';
import 'package:chat_app/core/errors/error_model.dart';
import 'package:chat_app/core/errors/firebase_error_handler.dart';
import 'package:chat_app/core/services/firebase_auth_service.dart';
import 'package:chat_app/core/services/firestore_service.dart';
import 'package:chat_app/core/services/shared_preferences.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final FirestoreService firestoreService;

  AuthRepoImpl(this.firebaseAuthService, this.firestoreService);
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
      final user = await getUserData(userId: userCred.uid);
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
      UserModel userModel = UserModel(
        id: userCred.uid,
        username: username,
        email: userCred.email!,
      );
      addDataToFirestore(userModel);
      saveDataLocally(userModel);
      return right(userModel);
    } catch (e) {
      firebaseAuthService.deleteUser();
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<void> addDataToFirestore(UserModel user) async {
    await firestoreService.addData(
      path: AppEndpoints.users,
      documentId: user.id,
      data: user.toJson(),
    );
  }

  @override
  Future<void> saveDataLocally(UserModel user) async {
    await SharedPrefs.setString(
      AppKeys.userData,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel> getUserData({required String userId}) async {
    final userData = await firestoreService.getData(
      path: AppEndpoints.users,
      documentId: userId,
    );
    return UserModel.fromJson(userData);
  }
}

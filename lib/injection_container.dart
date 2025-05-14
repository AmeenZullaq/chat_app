import 'package:chat_app/core/services/firebase_auth_service.dart';
import 'package:chat_app/core/services/firestore_service.dart';
import 'package:chat_app/core/services/firestore_service_impl.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:chat_app/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

class InjectionContainer {
  static GetIt getIt = GetIt.instance;

  static Future<void> initDependency() async {
    await authDependencyInit();
  }

  static Future<void> authDependencyInit() async {
    getIt.registerLazySingleton<FirebaseAuthService>(
      () {
        return FirebaseAuthService();
      },
    );
    getIt.registerLazySingleton<FirestoreService>(
      () {
        return FirestoreServiceImpl();
      },
    );
    getIt.registerLazySingleton<AuthRepo>(
      () {
        return AuthRepoImpl(
          getIt.get<FirebaseAuthService>(),
          getIt.get<FirestoreServiceImpl>(),
        );
      },
    );
    getIt.registerLazySingleton<AuthCubit>(
      () {
        return AuthCubit(
          getIt.get<AuthRepo>(),
        );
      },
    );
  }
}

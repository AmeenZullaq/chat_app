import 'package:chat_app/core/services/firebase_auth_service.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:chat_app/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class InjectionContainer {
  static initDependency() {
    authDependencyInit();
  }
}

authDependencyInit() {
  getIt.registerLazySingleton<FirebaseAuthService>(
    () {
      return FirebaseAuthService();
    },
  );
  getIt.registerLazySingleton<AuthRepo>(
    () {
      return AuthRepoImpl(
        getIt.get<FirebaseAuthService>(),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../features/auth/data/auth_repo_imp.dart';
import '../features/auth/domin/usecase/auth_repo_usecase.dart';
import '../features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class DependancyInjection {
  final GetIt locator = GetIt.instance;

  void setupLocator() {
    // Firebase Dependencies
    locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    locator.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);

    // Repository
    locator.registerLazySingleton<AuthRepoImp>(
      () => AuthRepoImp(
        googleSignIn: locator<GoogleSignIn>(),
        firebaseAuth: locator<FirebaseAuth>(),
        firestore: locator<FirebaseFirestore>(),
      ),
    );

    // Use Case
    locator.registerLazySingleton<AuthRepoUsecase>(
      () => AuthRepoUsecase(locator<AuthRepoImp>()),
    );

    // Cubit
    locator.registerFactory<AuthCubit>(
      () => AuthCubit(locator<AuthRepoUsecase>()),
    );
  }
}

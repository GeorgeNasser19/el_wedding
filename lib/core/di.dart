import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/core/shared_services/shared_service_usecase/shared_services_usecase.dart';
import 'package:el_wedding/core/shared_services/shared_services_rpeo_imp/shared_services_repo_impl.dart';
import 'package:el_wedding/features/auth/presentation/cubit/check_auth_cubit/check_auth_cubit.dart';
import 'package:el_wedding/features/employesViews/data/employes_repo_imp.dart';
import 'package:el_wedding/features/employesViews/domain/usecase/employ_repo_usecase.dart';
import 'package:el_wedding/features/employesViews/presentation/employes_cubit/employes_cubit.dart';
import 'package:el_wedding/features/userView/data/user_repo_impl/user_repo_impl.dart';
import 'package:el_wedding/features/userView/domain/usecase_user_view/usecase_user_view.dart';
import 'package:el_wedding/features/userView/presentation/cubit/user_view_cubit.dart';
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
    locator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

    // Repository
    locator.registerLazySingleton<AuthRepoImp>(
      () => AuthRepoImp(
        googleSignIn: locator<GoogleSignIn>(),
        firebaseAuth: locator<FirebaseAuth>(),
        firestore: locator<FirebaseFirestore>(),
      ),
    );

    locator.registerLazySingleton<SharedServicesRepoImpl>(
        () => SharedServicesRepoImpl());

    locator.registerLazySingleton<EmployesRepoImp>(() => EmployesRepoImp());

    locator.registerLazySingleton<UserRepoImpl>(() => UserRepoImpl());

    // Use Case
    locator.registerLazySingleton<AuthRepoUsecase>(
      () => AuthRepoUsecase(locator<AuthRepoImp>()),
    );
    locator.registerLazySingleton<SharedServicesUsecase>(
        () => SharedServicesUsecase(locator<SharedServicesRepoImpl>()));

    locator.registerLazySingleton<EmployRepoUsecase>(
        () => EmployRepoUsecase(locator<EmployesRepoImp>()));

    locator.registerLazySingleton<UsecaseUserView>(
        () => UsecaseUserView(locator<UserRepoImpl>()));

    // Cubit
    locator.registerFactory<AuthCubit>(
      () => AuthCubit(locator<AuthRepoUsecase>()),
    );
    locator.registerLazySingleton<CheckAuthCubit>(() => CheckAuthCubit(
        locator<AuthRepoUsecase>(), locator<SharedServicesUsecase>()));

    locator.registerLazySingleton<EmployesCubit>(() => EmployesCubit(
        locator<EmployRepoUsecase>(), locator<SharedServicesUsecase>()));

    locator.registerLazySingleton<UserViewCubit>(() => UserViewCubit(
        locator<UsecaseUserView>(), locator<SharedServicesUsecase>()));
  }
}

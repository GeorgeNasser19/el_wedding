// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:el_wedding/features/auth/data/model/user_model.dart';
// import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
// import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
// import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'features/employesViews/presentation/views/empolye_profile_first_enter.dart';
// import 'features/select_role/presentation/views/select_role_view.dart';
// import 'features/userView/presentation/views/user_view.dart';

// class CheckAuthPage extends StatelessWidget {
//   const CheckAuthPage({super.key});

//   // التحقق من وجود البريد الإلكتروني في المجموعات

//   Future<bool> checkIfRoleIsNotSelected(String userId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userId)
//           .get();

//       if (doc.exists) {
//         final data = doc.data();
//         {
//           return data?['isSelectedRole']; // تأكد من تطابق النوع
//         }
//       }
//     } catch (e) {
//       log("Error checking isSelectedRole: $e");
//     }
//     return true; // نفترض أن الدور غير محدد إذا حدث خطأ
//   }

//   // جلب بيانات المستخدم من Firestore
//   Future<UserModel?> fetchUserModel(
//     String userId,
//   ) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userId)
//           .get();
//       if (doc.exists) {
//         return UserModel.fromDoc(doc.data()!);
//       }
//     } catch (e) {
//       log("Error fetching user data: $e");
//     }
//     return null;
//   }

//   // جلب بيانات الموظف من Firestore
//   Future<EmployeeModel?> fetchEmployeeModel(
//     String userId,
//   ) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userId)
//           .get();
//       if (doc.exists) {
//         return EmployeeModel.fromDoc(doc.data()!);
//       }
//     } catch (e) {
//       log("Error fetching employee data: $e");
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, authSnapshot) {
//         if (authSnapshot.connectionState == ConnectionState.active) {
//           final user = authSnapshot.data;

//           if (user == null) {
//             // إذا لم يكن هناك مستخدم، يتم التوجيه إلى شاشة تسجيل الدخول مباشرة
//             return const LoginView();
//           }

//           return FutureBuilder<bool>(
//             future: checkIfRoleIsNotSelected(user.uid),
//             builder: (context, isSelectedRoleSnapshot) {
//               if (isSelectedRoleSnapshot.connectionState ==
//                   ConnectionState.done) {
//                 final isRoleNotSelected = isSelectedRoleSnapshot.data;

//                 log(isRoleNotSelected.toString());

//                 if (isRoleNotSelected == false) {
//                   return const SelectRoleView();
//                 }

//                 // متابعة تنفيذ المنطق في حال كان الدور محددًا
//                 return FutureBuilder<UserModel?>(
//                   future: fetchUserModel(user.uid),
//                   builder: (context, userSnapshot) {
//                     if (userSnapshot.connectionState == ConnectionState.done) {
//                       final userData = userSnapshot.data;
//                       log("${userData!.isProfileComplete.toString()} is profile");

//                       if (userData.isProfileComplete == false &&
//                           isRoleNotSelected == true) {
//                         return EmpolyeProfileFirstEnter(
//                             userName: userData.name);
//                       }

//                       switch (userData.role) {
//                         case 'user':
//                           return const UserView();
//                         case 'makeupArtist':
//                         case 'photographer':
//                           return FutureBuilder<EmployeeModel?>(
//                             future: fetchEmployeeModel(user.uid),
//                             builder: (context, employeeSnapshot) {
//                               if (employeeSnapshot.connectionState ==
//                                   ConnectionState.done) {
//                                 log("employ");
//                                 final employeeData = employeeSnapshot.data;

//                                 if (userData.isProfileComplete == true &&
//                                     userData.isSeletectRole == true) {
//                                   return EmpolyeProfile(
//                                       employesModel: employeeData!);
//                                 }

//                                 if (employeeData == null) {
//                                   return const Scaffold(
//                                     body: Center(
//                                       child: Text("Employee data not found"),
//                                     ),
//                                   );
//                                 }

//                                 return EmpolyeProfileFirstEnter(
//                                   userName: employeeData.fName,
//                                 );
//                               }

//                               return const Scaffold(
//                                 body:
//                                     Center(child: CircularProgressIndicator()),
//                               );
//                             },
//                           );
//                       }
//                     }

//                     return const Scaffold(
//                       body: Center(child: CircularProgressIndicator()),
//                     );
//                   },
//                 );
//               }

//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             },
//           );
//         }

//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }
// }

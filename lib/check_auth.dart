import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/core/widgets/error_page.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/select_role/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  Future<String?> _getUserRole(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return snapshot.data()?['role'] as String?;
      }
    } catch (e) {
      debugPrint("Error fetching user role: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          final user = authSnapshot.data;

          if (user == null) {
            // المستخدم غير مسجل الدخول
            return const LoginView();
          } else {
            // المستخدم مسجل الدخول، احضر الدور الخاص به
            return FutureBuilder<String?>(
              future: _getUserRole(user.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.done) {
                  if (roleSnapshot.hasData) {
                    final role = roleSnapshot.data;

                    if (role == null || role == "") {
                      // إذا كان الدور غير محدد
                      return const SelectRoleView();
                    }

                    // توجيه المستخدم حسب الدور
                    switch (role) {
                      case 'user':
                        return const UserView();
                      case 'makeupArtist':
                      case 'photographer':
                        final username = user.displayName ?? 'Guest';
                        return EmpolyeProfileFirstEnter(userName: username);
                      default:
                        return const ErrorPage(); // حالة غير متوقعة
                    }
                  } else {
                    // في حال لم يتم العثور على بيانات المستخدم
                    return const LoginView();
                  }
                }

                // شاشة انتظار أثناء جلب بيانات الدور
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            );
          }
        }

        // شاشة انتظار أثناء التحقق من حالة تسجيل الدخول
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

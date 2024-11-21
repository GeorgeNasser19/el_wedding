import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/core/widgets/error_page.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  Future<String?> _getUserRole(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        return snapshot.get('role');
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // المستخدم غير مسجل الدخول
            return const LoginView();
          } else {
            // المستخدم مسجل الدخول، احضر الدور الخاص به
            return FutureBuilder<String?>(
              future: _getUserRole(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    String role = snapshot.data!;
                    String username = user.displayName ?? 'Guest';

                    // توجيه المستخدم حسب الدور باستخدام switch case
                    switch (role) {
                      case 'User':
                        return const UserView();

                      case 'Makeup Artist' || "Photographer":
                        return EmpolyeProfileFirstEnter(userName: username);

                      default:
                        return const SelectRoleView();
                    }
                  } else {
                    // في حال لم يتم العثور على بيانات، توجه لصفحة خطأ
                    return const ErrorPage();
                  }
                }
                // شاشة انتظار أثناء جلب البيانات
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            );
          }
        }
        // شاشة انتظار أثناء التحقق من تسجيل الدخول
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

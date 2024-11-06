import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/core/widgets/error_page.dart';
import 'package:el_wedding/features/MakeUpAtristView/presentation/views/make_up_artist_view.dart';
import 'package:el_wedding/features/PotographerView/presentation/views/photo_grapher_view.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/auth/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

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
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    // استرجاع الدور من البيانات
                    String role = snapshot.data!.get('role');

                    // توجيه المستخدم حسب الدور باستخدام switch case
                    switch (role) {
                      case 'User':
                        return const UserView();
                      case 'Photographer':
                        return const PhotoGrapherView();
                      case 'Makeup Artist':
                        return const MakeUpArtistView();
                      default:
                        // في حال كان الدور غير معرف، توجه لصفحة افتراضية أو صفحة خطأ
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

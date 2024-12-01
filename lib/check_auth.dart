import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_wedding/features/auth/presentation/views/login_view.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_edit_profile.dart';
import 'package:el_wedding/features/employesViews/presentation/views/empolye_profile_first_enter.dart';
import 'package:el_wedding/features/select_role/presentation/views/select_role_view.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'features/auth/data/model/user_model.dart';
import 'features/employesViews/data/model/employes_model.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  Future<UserModel?> fetchUserModel(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromDoc(doc.data()!);
      }
    } catch (e) {
      log("Error fetching user data user: $e");
    }
    return null;
  }

  Future<EmployesModel?> fetchEmpolyModel(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (doc.exists) {
        return EmployesModel.fromDoc(doc.data()!);
      }
    } catch (e) {
      log("Error fetching user data employ: $e");
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
            return const LoginView();
          }

          // Fetch user data
          return FutureBuilder<UserModel?>(
            future: fetchUserModel(user.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                final userData = userSnapshot.data;
                log(userData.toString());
                if (userData?.role == null) {
                  return const SelectRoleView();
                }

                if (!userData!.isProfileComplete) {
                  return EmpolyeProfileFirstEnter(userName: userData.name);
                }
                switch (userData.role) {
                  case 'user':
                    return const UserView();
                  case 'makeupArtist':
                  case 'photographer':
                    return FutureBuilder(
                      future: fetchEmpolyModel(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final emoployData = snapshot.data;
                          log(emoployData.toString());
                          if (emoployData == null) {
                            return const Center(
                              child: Text("Employee data not found"),
                            );
                          }
                          return EmpolyeEditProfile(
                            employesModel: EmployesModel(
                              fName: emoployData.fName,
                              location: emoployData.location,
                              pNumber: emoployData.pNumber,
                              description: emoployData.description,
                              services: emoployData.services,
                              images: emoployData.images,
                              id: emoployData.id,
                              imageUrl: emoployData.imageUrl,
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                  default:
                    return const SelectRoleView();
                }
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

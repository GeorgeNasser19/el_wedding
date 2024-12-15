import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_wedding/core/helpers/sheard_pref.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/employe_edit_profile_body.dart';
import 'package:el_wedding/features/userView/presentation/views/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class EmpolyeProfile extends StatefulWidget {
  const EmpolyeProfile({super.key, required this.employesModel});

  final EmployeeModel employesModel;

  @override
  State<EmpolyeProfile> createState() => _EmpolyeProfileState();
}

class _EmpolyeProfileState extends State<EmpolyeProfile> {
  int cNumber = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      EmployeEditProfileBody(employesModel: widget.employesModel),
      const UserView()
    ];
    return SafeArea(
        child: Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  // employee image
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(top: 24),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.employesModel.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // employee full name
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(widget.employesModel.fName,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is SignOutSuccess) {
                        final role = SharedPrefs().getString("role_user");
                        context.go("/LoginView", extra: role);
                      }
                      if (state is SignOutFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () {
                          context.read<AuthCubit>().logout();
                        },
                        child: state is SignOutLoading
                            ? const CircularProgressIndicator()
                            : const Text("Log Out",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                      );
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cNumber,
                onTap: (vKey) {
                  setState(() {
                    cNumber = vKey;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'List',
                  ),
                ]),
            backgroundColor: const Color.fromARGB(255, 245, 241, 241),
            body: IndexedStack(
              index: cNumber,
              children: pages,
            )));
  }
}

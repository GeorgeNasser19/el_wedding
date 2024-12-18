import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:el_wedding/features/employesViews/presentation/widgets/employe_profile_contant.dart';
import 'package:el_wedding/features/userView/presentation/views/text.dart';
import 'package:flutter/material.dart';

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
      EmployeEditProfileContant(employesModel: widget.employesModel),
      const TestPage()
    ];
    return SafeArea(
        child: Scaffold(
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

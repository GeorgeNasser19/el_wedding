import 'package:el_wedding/router/router.dart';
import 'package:flutter/material.dart';

class ElWedding extends StatelessWidget {
  const ElWedding({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
    );
  }
}

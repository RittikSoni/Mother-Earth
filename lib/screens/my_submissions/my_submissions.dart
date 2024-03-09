import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:flutter/material.dart';

class MySubmissions extends StatelessWidget {
  const MySubmissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar(title: 'My Submissions'),
      body: const Text('Comming soon'),
    );
  }
}

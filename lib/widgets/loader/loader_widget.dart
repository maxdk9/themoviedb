import 'package:flutter/material.dart';


class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  
}

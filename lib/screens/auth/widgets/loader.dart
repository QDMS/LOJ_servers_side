import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      width: 100,
      child: Center(
        child: SpinKitThreeInOut(
          color: Color.fromARGB(255, 70, 47, 39),
        ),
      ),
    );
  }
}

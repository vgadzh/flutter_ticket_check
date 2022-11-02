import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CodeScreen extends StatelessWidget {
  final String code;
  const CodeScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(code)),
    );
  }
}

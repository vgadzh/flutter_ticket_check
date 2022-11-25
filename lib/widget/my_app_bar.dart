import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const MyAppBar({
    Key? key,
    required this.title,
    this.actions = const [],
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Styles.lightColor,
      foregroundColor: Styles.darkColor,
      title: Text(
        title,
        style: Styles.h6.copyWith(color: Styles.darkColor),
      ),
      actions: actions,
    );
  }
}

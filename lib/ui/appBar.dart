import 'package:flutter/material.dart';

//This class is used as a reusable component to display the appBar.
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const color = Color(0xff643165);
  final Color backgroundColor = color;
  final AppBar appBar;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BaseAppBar({Key? key, required this.appBar, required this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      toolbarHeight: 70,
      title: Image.asset(
        "assets/images/logoText.png",
        height: 150,
        width: 150,
      ),
      leading: Image.asset("assets/images/logo.png"),
      actions: [
        IconButton(
            icon: Icon(Icons.menu),
            iconSize: 40,
            onPressed: () => scaffoldKey.currentState?.openEndDrawer()),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

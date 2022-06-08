
import 'package:flutter/material.dart';

// ignore: camel_case_types
class customSliver extends StatelessWidget {
  const customSliver(
      {Key? key, required this.appBarTitle, required this.appBarBG})
      : super(key: key);

  final String appBarTitle;
  final String appBarBG;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        background: Image.network(
          appBarBG,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

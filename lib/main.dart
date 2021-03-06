import 'package:flutter/material.dart';

import 'currency_convert.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Convertor',
      theme: ThemeData(
        fontFamily: 'DMSans',
        primarySwatch: Colors.blue,
      ),
      home: const CurrencyConvertorPage(),
    );
  }
}

import 'package:credit_card/utils/colors.dart';
import 'package:credit_card/utils/contacts.dart';
import 'package:credit_card/views/home/index.dart';
import 'package:credit_card/views/home/match.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: xTransparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: xLight,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: xLight,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: Locale.fromSubtags(),
      theme: ThemeData(
        primaryColor: xPrimary,
        primaryColorLight: xLight,
        primaryColorDark: xDark,
        scaffoldBackgroundColor: xLight,
        textTheme: TextTheme(bodyText1: TextStyle(color: xDark)),
      ),
      home: VHomeMatch(),
    );
  }
}

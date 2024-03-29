import 'package:flutter/material.dart';
import 'package:flutter_api/ui/pages/homepage.dart';
import 'package:flutter_api/ui/posts/edit.dart';
import 'package:flutter_api/ui/posts/new.dart';
import 'package:flutter_api/ui/posts/show.dart';
import 'package:flutter_api/ui/users/show.dart';
import 'package:flutter_api/ui/users/sign_in.dart';
import 'package:flutter_api/ui/users/sign_up.dart';
import 'ui/users/edit.dart';
import 'models/user.dart';

void main() => runApp(APIApp());

class APIApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User.loginAtStartup(context);
    return MaterialApp(
      title: 'API App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        'posts/new': (context) => PostCreateForm(),
        'posts/show': (context) => PostShow(),
        'posts/edit': (context) => PostEditForm(),
        'users/new': (context) => SignUp(),
        'users/login': (context) => SignIn(),
        'users/show': (context) => UserPage(),
        'users/edit': (context) => UserEdit(),
      },
    );
  }
}


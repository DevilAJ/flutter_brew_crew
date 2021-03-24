import 'package:brew_crew/screens/authenticate/login.dart';
import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

class Athenticate extends StatefulWidget {
  @override
  _AthenticateState createState() => _AthenticateState();
}

class _AthenticateState extends State<Athenticate> {
  bool signInPage = true;
  void changeState() {
    setState(
      () {
        signInPage = !signInPage;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return signInPage
        ? signIn(
            changeState: changeState,
          )
        : signUp(
            changeState: changeState,
          );
  }
}

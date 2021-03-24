import 'file:///C:/Users/ANIKET%20JAISWAL/Desktop/Study/Flutter%20Projects/brew_crew/lib/components/constants.dart';
import 'package:brew_crew/components/loading.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class signUp extends StatefulWidget {
  final Function changeState;
  signUp({this.changeState});
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String error = "";
  String email = "", password = "";
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              title: Text("Sign Up to Brew Crew"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.changeState();
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Enter email here" : null,
                      cursorColor: Colors.brown,
                      decoration: kInputInputBorder.copyWith(
                        hintText: 'Email',
                      ),
                      onChanged: (val) {
                        setState(
                          () {
                            email = val;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) => val.length < 6
                          ? "Enter password (more than 5 char)"
                          : null,
                      obscureText: true,
                      decoration: kInputInputBorder.copyWith(
                        hintText: 'Password',
                      ),
                      cursorColor: Colors.brown,
                      onChanged: (val) {
                        setState(
                          () {
                            password = val;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton(
                      color: Colors.brown[400],
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() => loading = true);
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .signUpWithEmailAndPassword(email, password);
                          if (result is String) {
                            setState(
                              () {
                                loading = false;
                                error =
                                    result.substring(result.indexOf(']') + 2);
                              },
                            );
                          }
                        }
                        ;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

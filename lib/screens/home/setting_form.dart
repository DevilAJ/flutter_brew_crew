import 'package:brew_crew/components/loading.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/components/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  String _currentName, _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Update your brew setting.",
                  style: TextStyle(fontSize: 18, color: Colors.brown),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration:
                      kInputInputBorder.copyWith(hintText: userData.name),
                  validator: (val) =>
                      val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(
                  height: 20,
                ),
                //Dropdown
                DropdownButtonFormField(
                  decoration: kInputInputBorder,
                  value: _currentSugar ?? userData.sugars,
                  onChanged: (val) => setState(() => _currentSugar = val),
                  items: sugars.map(
                    (sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text(
                          '$sugar sugars',
                          style: TextStyle(color: Colors.brown),
                        ),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                //Slider
                Slider(
                  activeColor:
                      Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor:
                      Colors.brown[_currentStrength ?? userData.strength],
                  min: 100,
                  max: 900,
                  divisions: 8,
                  onChanged: (val) =>
                      setState(() => _currentStrength = val.toInt()),
                  value: _currentStrength == null
                      ? userData.strength.toDouble()
                      : _currentStrength.toDouble(),
                  label: "Coffee strength",
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.brown,
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await DatabaseService(uid: user.uid).updateUserData(
                        _currentName ?? userData.name,
                        _currentSugar ?? userData.sugars,
                        _currentStrength ?? userData.strength);
                    _currentName = null;
                    _currentSugar = null;
                    _currentStrength = null;
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            // ignore: missing_return
          );
        } else
          return Loading();
      },
    );
  }
}

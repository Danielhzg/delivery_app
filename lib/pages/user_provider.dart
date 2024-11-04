import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Nama Pengguna';

  String get name => _name;

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }
}

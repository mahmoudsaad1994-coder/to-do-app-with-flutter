
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  // save data in storge
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // get data from storge
  bool _loadThemeFromBox() => _box.read<bool>(_key) ?? false; //if null => false

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchThem() {
    // toggle theme mode 
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark); 
    // and save reslte in storge
    _saveThemeToBox(!_loadThemeFromBox());
  }
}

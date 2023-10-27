import 'dart:typed_data';

import 'package:crm/main.dart';
import 'package:crm/model/contact_model.dart';
import 'package:crm/utils/pref_utils.dart';
import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  int getDateFilter() {
    return PrefUtils.getDateFilter();
  }

  setDateFilter(int i) {
    PrefUtils.setDateFilter(i);
    notifyListeners();
  }
}

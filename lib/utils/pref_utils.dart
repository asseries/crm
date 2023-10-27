// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crm/extensions/extensions.dart';
import 'package:crm/extensions/time_extensions.dart';
import 'package:crm/model/state_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/contact_model.dart';
import '../model/login_response.dart';
import '../model/state_model.dart';
import 'constants.dart';

class PrefUtils {
  static SharedPreferences? _singleton;

  static const PREF_BASE_IMAGE_URL = "base_image_url";

  static const PREF_BDM_ITEMS = "bdm_items";
  static const PREF_SELECTED_BRANCH = "selected_branch";
  static const PREF_FAVORITES = "favorites";
  static const PREF_BASE_URL = "base_url";
  static const PREF_FCM_TOKEN = "fcm_token";
  static const PREF_TOKEN = "token";
  static const PREF_CATEGORY_LIST = "category_list";
  static const PREF_BASKET = "basket";
  static const PREF_USER = "user";
  static const PREF_LANG = "lang";
  static const PREF_SELECTED_CARD_ID = "selected_card_id";
  static const PREF_FIRST_DELETE_COACH = "first_delete_coach";
  static const PREF_SELECTED_WORKER = "selected_workder";

  static const PREF_CONNECT = "connected";
  static const PREF_APP_TYPE = "app_type";
  static const PREF_THEME_MODE = "theme_mode";
  static const PREF_REC_FOLDER = "rec_folder";
  static const PREF_CALL_STATE = "call_state";
  static const PREF_LAST_DATE = "last_date";
  static const PREF_DATE_FILTER = "date_filter";
  static const PREF_CHECK = "check";
  static const PREF_IP = "ip";

  static SharedPreferences? getInstance() {
    return _singleton;
  }

  static initInstance() async {
    _singleton = await SharedPreferences.getInstance();
  }

  static reload() async {
    _singleton?.reload();
  }

  static int getSelectedCardId() {
    return _singleton?.getInt(PREF_SELECTED_CARD_ID) ?? -1;
  }

  static Future<Future<bool>?> setSelectedCardId(int value) async {
    return _singleton?.setInt(PREF_SELECTED_CARD_ID, value);
  }

  static Future<Future<bool>?> clearSelectedWorkers() async {
    return _singleton?.setString(PREF_SELECTED_WORKER, jsonEncode([].toList()));
  }

  static String getBaseImageUrl() {
    return _singleton?.getString(PREF_BASE_IMAGE_URL) ?? "";
  }

  static Future<Future<bool>?> setBaseImageUrl(String value) async {
    return _singleton?.setString(PREF_BASE_IMAGE_URL, value);
  }

  static String getBaseUrl() {
    return _singleton?.getString(PREF_BASE_URL) ?? "";
  }

  static Future<Future<bool>?> setBaseUrl(String value) async {
    return _singleton?.setString(PREF_BASE_URL, value);
  }

  static String getFCMToken() {
    return _singleton?.getString(PREF_FCM_TOKEN) ?? "";
  }

  static Future<Future<bool>?> setFCMToken(String value) async {
    return _singleton?.setString(PREF_FCM_TOKEN, value);
  }

  static String getToken() {
    return _singleton?.getString(PREF_TOKEN) ?? "";
  }

  static Future<Future<bool>?> setToken(String value) async {
    return _singleton?.setString(PREF_TOKEN, value);
  }

  static List<String> getFavoriteList() {
    return _singleton?.getStringList(PREF_FAVORITES) ?? [];
  }

  static Future<Future<bool>?> setLang(String value) async {
    return _singleton?.setString(PREF_LANG, value);
  }

  static String getFirstDeleteCoach() {
    return _singleton?.getString(PREF_FIRST_DELETE_COACH) ?? "1";
  }

  static Future<Future<bool>?> setFirstDeleteCoach(String value) async {
    return _singleton?.setString(PREF_FIRST_DELETE_COACH, value);
  }

  static void clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  //support
  static bool getConnected() {
    return _singleton?.getBool(PREF_CONNECT) ?? false;
  }

  static Future<Future<bool>?> setConnected(bool value) async {
    return _singleton?.setBool(PREF_CONNECT, value);
  }

  //support
  static int getAppType() {
    return _singleton?.getInt(PREF_APP_TYPE) ?? -1;
  }

  static Future<Future<bool>?> setAppType(int value) async {
    return _singleton?.setInt(PREF_APP_TYPE, value);
  }

  //FOLDER
  static String getRecFolder() {
    return _singleton?.getString(PREF_REC_FOLDER) ?? "";
  }

  static Future<Future<bool>?> setRecFolder(String value) async {
    return _singleton?.setString(PREF_REC_FOLDER, value);
  }

  //
  static ThemeMode? getThemeMode() {
    int? theme = _singleton?.getInt(PREF_THEME_MODE);
    ThemeMode? themeMode = ThemeMode.dark;
    if (theme == null || theme == -1) {
      themeMode = null;
    } else if (theme == 1) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    return themeMode;
  }

  static Future<Future<bool>?> setThemeMode(ThemeMode? themeMode) async {
    int value = 2;
    if (themeMode == null) {
      return _singleton?.setInt(PREF_THEME_MODE, -1);
    }
    if (themeMode == ThemeMode.light) {
      value = 1;
    }
    if (themeMode == ThemeMode.dark) {
      value = 2;
    }
    return _singleton!.setInt(PREF_THEME_MODE, value);
  }

  //chheck
  static String? getCheck() {
    return _singleton!.getString(PREF_CHECK);
  }

  static Future<bool>? setCheck(String value) async {
    return _singleton!.setString(PREF_CHECK, value);
  }

  static List<StateModelForPrefs> getCallStateList() {
    var json = _singleton!.getString(PREF_CALL_STATE);
    if (json == null) {
      return [];
    }
    var items = (jsonDecode(json) as List<dynamic>).map((js) => StateModelForPrefs.fromJson(js));
    return items.toList();
  }

  static Future<bool> addCallState(StateModelForPrefs item) async {
    var items = getCallStateList();
    items.add(item);
    var r = await _singleton?.setString(PREF_CALL_STATE, jsonEncode(items));
    return r ?? false;
  }

  static Future<bool> removeCallState(StateModelForPrefs item) async {
    var items = getCallStateList();
    List<StateModelForPrefs> newItems = [];
    for (var element in items) {
      if  (
      // ((callLogTime - audioTime).abs() <= 20000)
      (element.date.getYearOfEproch() == item.date.getYearOfEproch()) &&
          (element.date.getMonthOfEproch() == item.date.getMonthOfEproch()) &&
          (element.date.getDayOfEproch() == item.date.getDayOfEproch()) &&
          (element.date.getHourOfEproch() == item.date.getHourOfEproch()) &&
          ((element.date.getMinuteOfEproch() == item.date.getMinuteOfEproch() &&
              (element.date.getSecondOfEproch() - item.date.getSecondOfEproch()).abs() < 2) ||
              (((element.date.getMinuteOfEproch() - item.date.getMinuteOfEproch()).abs() == 1) &&
                  (element.date.getSecondOfEproch() - item.date.getSecondOfEproch()).abs() < 60))
      // && ((audioDuration - callLogDuration).abs() < 2)
      ) {

      }else{
        newItems.add(element);
      }
    }
    var r = await _singleton?.setString(PREF_CALL_STATE, jsonEncode(newItems));
    return r ?? false;
  }

  static Future<bool?> clearCallState() async {
    var result = await _singleton?.setString(PREF_CALL_STATE, jsonEncode([].toList()));
    return result;
  }

  //support
  static int getLastDate() {
    return _singleton?.getInt(PREF_LAST_DATE) ?? 0;
  }

  static Future<bool> setLastDate(int value) async {
    return _singleton!.setInt(PREF_LAST_DATE, value);
  }

  //support
  static int getDateFilter() {
    return _singleton?.getInt(PREF_DATE_FILTER) ?? 7;
  }

  static Future<bool> setDateFilter(int value) async {
    return _singleton!.setInt(PREF_DATE_FILTER, value);
  }

  //support
  static String getIp() {
    return _singleton?.getString(PREF_IP) ?? "";
  }

  static Future<bool> setIp(String value) async {
    return _singleton!.setString(PREF_IP, value);
  }

  static Future<Future<bool>?> setUser(LoginResponse value) async {
    return _singleton?.setString(PREF_USER, jsonEncode(value.toJson()));
  }

  static LoginResponse? getUser() {
    if (_singleton?.getString(PREF_USER) == null) {
      return null;
    } else {
      return LoginResponse.fromJson(jsonDecode(_singleton?.getString(PREF_USER) ?? ""));
    }
  }
}

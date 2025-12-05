import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../data/settings_dao.dart';

class LanguageCubit extends Cubit<Locale> {
  final SettingsDao _settingsDao;
  LanguageCubit(this._settingsDao) : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final val = await _settingsDao.getValue('language');
    if (val != null) emit(Locale(val));
  }

  Future<void> changeLanguage(Locale locale) async {
    emit(locale);
    await _settingsDao.setValue('language', locale.languageCode);
  }
}

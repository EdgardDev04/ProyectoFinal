import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_cubit.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.select((LanguageCubit c) => c.state);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text('🇺🇸', style: TextStyle(fontSize: 18)),
          title: Text('English'),
          trailing: current.languageCode == 'en' ? Icon(Icons.check) : null,
          onTap: () {
            context.read<LanguageCubit>().changeLanguage(const Locale('en'));
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Text('🇪🇸', style: TextStyle(fontSize: 18)),
          title: Text('Español'),
          trailing: current.languageCode == 'es' ? Icon(Icons.check) : null,
          onTap: () {
            context.read<LanguageCubit>().changeLanguage(const Locale('es'));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}



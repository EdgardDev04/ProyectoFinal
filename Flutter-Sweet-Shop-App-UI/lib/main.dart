import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/bloc/cart_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/repo/cart_repository.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/product_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/category_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/product_repository.dart';

import 'core/theme/theme.dart';
import 'features/home_feature/presentation/bloc/theme_cubit.dart';
import 'features/home_feature/presentation/screens/splash_screen.dart';
import 'package:flutter_sweet_shop_app_ui/data/db.dart';

import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Evita que Google Fonts intente descargar online
  GoogleFonts.config.allowRuntimeFetching = true;

  await AppDatabase.deleteDatabaseFile();
  await AppDatabase.instance;

  final productRepo = ProductRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => CartCubit(CartRepository())..loadCart()),
        BlocProvider(create: (_) => ProductCubit(productRepo)..loadProducts()),
        BlocProvider(
          create: (_) => CategoryCubit(productRepo)..loadCategories(),
        ),
      ],
      child: const App(),
    ),
  );
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return BlocBuilder<ThemeCubit, ThemeMode?>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: SplashScreen(),
        );
      },
    );
  }
}

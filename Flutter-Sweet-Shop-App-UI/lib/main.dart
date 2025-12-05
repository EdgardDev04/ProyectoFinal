import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_sweet_shop_app_ui/features/cart_feature/presentation/bloc/cart_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/cart_feature/repo/cart_repository.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/presentation/bloc/product_cubit.dart';
import 'package:flutter_sweet_shop_app_ui/features/home_feature/repo/product_repository.dart';

import 'core/theme/theme.dart';
import 'features/home_feature/presentation/bloc/theme_cubit.dart';
import 'features/home_feature/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => ThemeCubit()),
    BlocProvider(create: (_) => CartCubit(CartRepository())..loadCart()),
    BlocProvider(create: (_) => ProductCubit(ProductRepository())..loadProducts()),
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

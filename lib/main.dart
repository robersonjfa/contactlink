import 'package:contactlink/routes.dart';
import 'package:contactlink/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:contactlink/bloc/auth_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(), // Initialize your AuthBloc here
        ),
        // Add more BlocProviders for other blocs if needed
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: Consumer<ThemeManager>(
          builder: (context, themeManager, child) {
            return MaterialApp(
              title: 'ContactLink App',
              theme: themeManager.themeData,
              initialRoute: AppRoutes.splash,
              routes: AppRoutes.define(),
            );
          },
        ),
      ),
    );
  }
}

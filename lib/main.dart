import 'package:flutter/material.dart';
import 'package:form_app/providers/user_provider.dart';
import 'package:form_app/screens/address_form_screen.dart';
import 'package:form_app/screens/address_list_screen.dart';
import 'package:form_app/screens/chat_screen.dart';
import 'package:form_app/screens/home_screen.dart';
import 'package:form_app/screens/user_form_screen.dart';
import 'package:form_app/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final userProvider = UserProvider();
  await userProvider.loadUser();
  
  runApp(MyApp(userProvider: userProvider));
}

class MyApp extends StatelessWidget {
  final UserProvider userProvider;

  const MyApp({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: userProvider,
      child: MaterialApp(
        title: 'Registro de Usuarios',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.light,
            primary: Colors.red,
            secondary: Colors.redAccent,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.montserratTextTheme(),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.dark,
            primary: Colors.red.shade200,
            secondary: Colors.red.shade300,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.montserratTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
          Locale('en', 'US'),
        ],
        locale: const Locale('es', 'ES'),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          UserFormScreen.routeName: (ctx) => const UserFormScreen(),
          UserProfileScreen.routeName: (ctx) => const UserProfileScreen(),
          AddressFormScreen.routeName: (ctx) => const AddressFormScreen(),
          AddressListScreen.routeName: (ctx) => const AddressListScreen(),
          ChatScreen.routeName: (ctx) => const ChatScreen(),
        },
      ),
    );
  }
}

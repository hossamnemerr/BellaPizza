import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF1A1008),
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(const PizzaApp());
}

class PizzaApp extends StatefulWidget {
  const PizzaApp({super.key});
  @override State<PizzaApp> createState() => _PizzaAppState();
}

class _PizzaAppState extends State<PizzaApp> {
  final _cart = CartNotifier();
  @override void dispose() { _cart.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => CartProvider(
    notifier: _cart,
    child: MaterialApp(
      title: 'Slice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],
      locale: const Locale('ar', ''),
      initialRoute: '/',
      routes: {
        '/':        (_) => const SplashScreen(),
        '/login':   (_) => const LoginScreen(),
        '/menu':    (_) => const MenuScreen(),
        '/orders':  (_) => const OrderScreen(),
        '/tables':  (_) => const _StubScreen('Tables'),
        '/billing': (_) => const _StubScreen('Billing'),
      },
      scrollBehavior: const _BouncingScroll(),
      builder: (_, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF1A1008),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: child!,
      ),
    ),
  );
}

class _BouncingScroll extends ScrollBehavior {
  const _BouncingScroll();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails _) => child;
}

class _StubScreen extends StatelessWidget {
  final String title;
  const _StubScreen(this.title);

  int _getIndex() {
    if (title.toLowerCase() == 'tables') return 0;
    if (title.toLowerCase() == 'billing') return 3;
    return 1;
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) Navigator.of(context).pushReplacementNamed('/menu');
    },
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        title: Text(title.toUpperCase(), style: const TextStyle(
            color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 1.2)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/menu')),
      ),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.construction_rounded, size: 48, color: AppColors.outlineVariant),
        const SizedBox(height: 16),
        Text('$title screen coming soon',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
      ])),
      bottomNavigationBar: BottomNavBar(currentIndex: _getIndex()),
    ),
  );
}

// Importing necessary packages for the app
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';
import 'screens/staff_profile_screen.dart';
import 'screens/about_us.dart';
import 'screens/payment_selection.dart';
import 'screens/payment_successful.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Main function that starts the app
void main() async {
  // Initialize Flutter for the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with status tracking
  bool firebaseReady = false;
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCYpuZh7JaIb1LwN7HJN0VtzLS4HCtCLoo",
          authDomain: "bellapizza-98bac.firebaseapp.com",
          projectId: "bellapizza-98bac",
          storageBucket: "bellapizza-98bac.firebasestorage.app",
          messagingSenderId: "570794251492",
          appId: "1:570794251492:web:f00a98f12d9da7cf6548f1",
          measurementId: "G-MEASUREMENT_ID",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    firebaseReady = true;
    debugPrint("✅ Firebase initialized successfully");
  } catch (e) {
    debugPrint("❌ Firebase initialization failed: $e");
  }

  // Set preferred screen orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Disable logs in production
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // Run initial data bootstrap in background to avoid blocking UI
  if (firebaseReady) {
    _uploadInitialMenuIfNeeded();
    _uploadInitialStaffIfNeeded();
  }
  
  runApp(const XcoreRestaurantApp());
}

// Function to upload initial staff to database if empty
Future<void> _uploadInitialStaffIfNeeded() async {
  final staffCollection = FirebaseFirestore.instance.collection('staff');
  final snapshot = await staffCollection.limit(1).get();

  if (snapshot.docs.isEmpty) {
    debugPrint("قاعدة بيانات الموظفين فارغة، جاري رفع بيانات الموظفين...");
    final List<Map<String, dynamic>> initialStaff = [
      {
        'name': 'أحمد محمد',
        'role': 'cashier',
        'salary': 5000,
        'img': 'https://i.pravatar.cc/150?u=ahmed',
      },
      {
        'name': 'سارة أحمد',
        'role': 'manager',
        'salary': 8000,
        'img': 'https://i.pravatar.cc/150?u=sara',
      },
      {
        'name': 'محمود علي',
        'role': 'chef',
        'salary': 6500,
        'img': 'https://i.pravatar.cc/150?u=mahmoud',
      },
    ];

    for (var staff in initialStaff) {
      await staffCollection.add(staff);
    }
    debugPrint("تم رفع بيانات الموظفين بنجاح!");
  }
}

// Function to upload initial menu to database if empty
Future<void> _uploadInitialMenuIfNeeded() async {
  // Get menu collection from Firestore
  final menuCollection = FirebaseFirestore.instance.collection('menu_items');
  // Check if there are items in the collection
  final snapshot = await menuCollection.limit(1).get();

  // If collection is empty, upload sample menu
  if (snapshot.docs.isEmpty) {
    // Print upload start message
    debugPrint("قاعدة البيانات فارغة، جاري رفع المنيو التجريبي...");
    // List of initial menu items
    final List<Map<String, dynamic>> initialItems = [
      {
        'name': 'بيتزا مارجريتا',
        'description':
            'صلصة طماطم إيطالية، جبنة موزاريلا، ريحان طازج وزيت زيتون.',
        'price': 45.0,
        'categoryId': 'pizza',
        'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbad80ad38?auto=format&fit=crop&w=500',
        'chips': ['نباتي', 'الأكثر مبيعاً'],
      },
      {
        'name': 'بيتزا بيبروني',
        'description':
            'شرائح بيبروني بقري مدخن مع طبقة غنية من جبنة الموزاريلا.',
        'price': 55.0,
        'categoryId': 'pizza',
        'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=500',
        'chips': ['حار قليلاً'],
      },
      {
        'name': 'أجنحة دجاج بوفالو',
        'description': '6 قطع من أجنحة الدجاج المقلية بصلصة البوفالو الحارة.',
        'price': 35.0,
        'categoryId': 'appetizers',
        'imageUrl': 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&w=500',
        'chips': ['مقبلات'],
      },
      {
        'name': 'سلطة سيزر',
        'description': 'خس طازج، صوص سيزر، قطع خبز محمص وجبنة بارميزان.',
        'price': 30.0,
        'categoryId': 'salads',
        'imageUrl': 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=500',
        'chips': ['صحي'],
      },
      {
        'name': 'بيبسي',
        'description': 'مشروب غازي منعش 330 مل.',
        'price': 7.0,
        'categoryId': 'drinks',
        'imageUrl': 'https://images.unsplash.com/photo-1629203851020-901c045c25bd?auto=format&fit=crop&w=500',
        'chips': ['بارد'],
      },
    ];

    // Upload each item to the database
    for (var item in initialItems) {
      // Add item to the collection
      await menuCollection.add(item);
    }
    debugPrint("تم رفع المنيو بنجاح!");
  }
}

class XcoreRestaurantApp extends StatefulWidget {
  const XcoreRestaurantApp({super.key});
  @override
  State<XcoreRestaurantApp> createState() => _XcoreRestaurantAppState();
}

class _XcoreRestaurantAppState extends State<XcoreRestaurantApp> {
  final _cart = CartNotifier();
  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CartProvider(
        notifier: _cart,
        child: MaterialApp(
          title: 'BELLA PIZZA',
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [
            Locale('ar', 'SA'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginPage(),
            '/menu': (_) => const MenuScreen(),
            '/orders': (_) => const OrderScreen(),
            '/profile': (context) => const StaffProfileScreen(),
            '/about': (_) => const AboutUsScreen(),
            '/billing': (_) => const PaymentSelectionScreen(),
            '/payment-success': (_) => const PaymentSuccessfulScreen(),
          },
          scrollBehavior: const _BouncingScrollBehavior(),
          builder: (_, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: AppColors.background,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: child!,
          ),
        ),
      );
}

class _BouncingScrollBehavior extends ScrollBehavior {
  const _BouncingScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails _) =>
      child;
}


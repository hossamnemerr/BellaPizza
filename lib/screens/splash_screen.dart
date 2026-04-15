import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logo, _title, _sub, _footer;

  @override
  void initState() {
    super.initState();
    _ctrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _logo   = _iv(0.0,  0.40);
    _title  = _iv(0.25, 0.60);
    _sub    = _iv(0.45, 0.75);
    _footer = _iv(0.65, 1.00);
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  Animation<double> _iv(double b, double e) =>
      CurvedAnimation(parent: _ctrl, curve: Interval(b, e, curve: Curves.easeOut));

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Stack(children: [
      // Warm red glow top-right
      Align(alignment: Alignment.topRight,
        child: Transform.translate(offset: const Offset(100, -100),
          child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(width: 350, height: 350,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x22FF3B2F)))))),
      // Warm gold glow bottom-left
      Align(alignment: Alignment.bottomLeft,
        child: Transform.translate(offset: const Offset(-100, 100),
          child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(width: 300, height: 300,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x18FFB930)))))),

      SafeArea(child: Column(children: [
        Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Logo cluster
          FadeTransition(opacity: _logo, child: Stack(alignment: Alignment.center, children: [
            // Outer glow ring
            Container(width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.25),
                  Colors.transparent]),
              )),
            // Inner red circle
            Container(width: 88, height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF8B1A12), Color(0xFF5A0A06)]),
              )),
            // Pizza icon
            const Icon(Icons.local_pizza_rounded, size: 52, color: AppColors.gold),
          ])),

          const SizedBox(height: 28),

          // Brand name
          FadeTransition(opacity: _title, child: Column(children: [
            Text('SLICE', style: GoogleFonts.oswald(
                fontSize: 56, fontWeight: FontWeight.w700, color: AppColors.onSurface,
                letterSpacing: 6.0, height: 1.0)),
            const SizedBox(height: 4),
            Text('PIZZA', style: GoogleFonts.oswald(
                fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.gold,
                letterSpacing: 8.0)),
          ])),

          const SizedBox(height: 20),

          // Divider — warm gradient
          FadeTransition(opacity: _sub, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 40, height: 1.5, color: AppColors.primary.withValues(alpha: 0.4)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Icon(Icons.fiber_manual_record, size: 6, color: AppColors.gold)),
            Container(width: 40, height: 1.5, color: AppColors.primary.withValues(alpha: 0.4)),
          ])),

          const SizedBox(height: 16),

          FadeTransition(opacity: _sub, child: Text('طازج · ساخن · لذيذ',
            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant, letterSpacing: 2.0))),
        ]))),

        // Footer
        FadeTransition(opacity: _footer, child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(width: 28, height: 28,
              child: CircularProgressIndicator(strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
            const SizedBox(height: 12),
            Text('جارٍ التحميل...', style: GoogleFonts.nunito(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
          ]),
        )),
      ])),
    ]),
  );
}

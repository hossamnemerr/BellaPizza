// Splash screen shown at app startup with animated logo and transition
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Stateful splash page
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logo, _title, _sub, _footer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _logo = _iv(0.0, 0.40);
    _title = _iv(0.25, 0.60);
    _sub = _iv(0.45, 0.75);
    _footer = _iv(0.65, 1.00);
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  Animation<double> _iv(double b, double e) => CurvedAnimation(
      parent: _ctrl, curve: Interval(b, e, curve: Curves.easeOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.primary.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
              child: Column(children: [
            Expanded(
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
              FadeTransition(
                  opacity: _logo,
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            AppColors.primary.withValues(alpha: 0.25),
                            Colors.transparent
                          ]),
                        )),
                    Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                              colors: [AppColors.primaryContainer, AppColors.surface]),
                        )),
                    const Icon(Icons.local_pizza_rounded,
                        size: 52, color: AppColors.primary),
                  ])),
              const SizedBox(height: 28),
              FadeTransition(
                  opacity: _title,
                  child: Column(children: [
                    Text('BELLA',
                        style: GoogleFonts.oswald(
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            letterSpacing: 6.0,
                            height: 1.0)),
                    const SizedBox(height: 4),
                    Text('PIZZA',
                        style: GoogleFonts.oswald(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                            letterSpacing: 8.0)),
                  ])),
              const SizedBox(height: 20),
              FadeTransition(
                  opacity: _sub,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 40,
                            height: 1.5,
                            color: AppColors.primary.withValues(alpha: 0.4)),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Icon(Icons.fiber_manual_record,
                                size: 6, color: AppColors.primary)),
                        Container(
                            width: 40,
                            height: 1.5,
                            color: AppColors.primary.withValues(alpha: 0.4)),
                      ])),
              const SizedBox(height: 16),
              FadeTransition(
                  opacity: _sub,
                  child: Text('طازج · ساخن · لذيذ',
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 2.0))),
            ]))),
            FadeTransition(
                opacity: _footer,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary))),
                    const SizedBox(height: 12),
                    Text('جارٍ التحميل...',
                        style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.5)),
                  ]),
                )),
          ])),
        ]),
      );
}

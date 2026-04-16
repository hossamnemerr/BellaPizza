import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  static const _pinLength = 4;
  static const _correctPin = '1234';
  final List<String> _digits = [];
  bool _hasError = false;

  late final List<AnimationController> _keyCtrls;
  late final List<Animation<double>> _keyScales;
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _keyCtrls = List.generate(12, (_) {
      return AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    });
    _keyScales = List.generate(12, (i) =>
        Tween<double>(begin: 1.0, end: 0.85).animate(
            CurvedAnimation(parent: _keyCtrls[i], curve: Curves.easeInOut)));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0,   end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end:  12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:  12.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end:  10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:  10.0, end:  -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:  -6.0, end:   6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:   6.0, end:   0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    for (final c in _keyCtrls) {
      c.dispose();
    }
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _tap(int idx) async {
    await _keyCtrls[idx].forward();
    _keyCtrls[idx].reverse();
  }

  void _onDigit(String d, int idx) {
    HapticFeedback.lightImpact(); _tap(idx);
    if (_digits.length >= _pinLength) return;
    setState(() { _hasError = false; _digits.add(d); });
    if (_digits.length == _pinLength) _verify();
  }

  void _onBack(int idx) {
    HapticFeedback.lightImpact(); _tap(idx);
    if (_digits.isEmpty) return;
    setState(() { _hasError = false; _digits.removeLast(); });
  }

  void _onClear(int idx) {
    HapticFeedback.mediumImpact(); _tap(idx);
    if (_digits.isEmpty) return;
    setState(() { _hasError = false; _digits.clear(); });
  }

  void _verify() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (_digits.join() == _correctPin) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/menu');
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _hasError = true);
      // Wait for the shake animation and visual feedback to complete
      await _shakeCtrl.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _digits.clear();
          _hasError = false;
        });
      }
    }
  }

  Widget _dot(int i) {
    final filled = i < _digits.length;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      width: filled ? 22 : 14,
      height: filled ? 22 : 14,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _hasError ? AppColors.error : (filled ? AppColors.gold : Colors.transparent),
        border: Border.all(
            color: (filled || _hasError) ? Colors.transparent : AppColors.outline.withOpacity(0.5),
            width: 2),
        boxShadow: _hasError
            ? [BoxShadow(color: AppColors.error.withOpacity(0.4), blurRadius: 12, spreadRadius: 1)]
            : filled
            ? [BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 12, spreadRadius: 1)]
            : null,
      ),
    );
  }

  Widget _key({required int idx, String? digit, Widget? child,
    bool transparent = false, IconData? icon, Color? iconColor, VoidCallback? onTap}) {
    return ScaleTransition(scale: _keyScales[idx],
      child: GestureDetector(
        onTap: onTap ?? () => _onDigit(digit!, idx),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: transparent ? null : BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerHigh,
            border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5), width: 1.5),
          ),
          child: Center(
            child: child ?? (digit != null
                ? Text(digit, style: GoogleFonts.oswald(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
                height: 1.0))
                : Icon(icon, size: 28, color: iconColor ?? AppColors.onSurfaceVariant)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _digits.length == _pinLength;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        scrolledUnderElevation: 0, automaticallyImplyLeading: false, titleSpacing: 16,
        title: Row(children: [
          const Icon(Icons.local_pizza_rounded, color: AppColors.gold, size: 26),
          const SizedBox(width: 10),
          Text('SLICE PIZZA', style: GoogleFonts.oswald(
              fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.gold, letterSpacing: 2.0)),
        ]),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16),
              child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      color: AppColors.surfaceContainerHigh,
                      border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5), width: 1)),
                  child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 22))),
        ],
      ),
      body: Stack(children: [
        // Glow top-right using a safer method (radial gradient)
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        SafeArea(child: Column(children: [
          Expanded(child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 32),

              // Pizza icon header
              Container(width: 72, height: 72,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryContainer.withOpacity(0.3),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5)),
                  child: const Icon(Icons.lock_rounded, color: AppColors.primary, size: 32)),

              const SizedBox(height: 20),

              Text('تسجيل الدخول', style: GoogleFonts.oswald(
                  fontSize: 38, fontWeight: FontWeight.w600, color: AppColors.onSurface,
                  letterSpacing: 0.5), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('أدخل الرمز السري الخاص بك', style: GoogleFonts.nunito(
                  fontSize: 14, color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),

              const SizedBox(height: 28),

              // PIN dots
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(
                    offset: Offset(_shakeAnim.value, 0), child: child!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pinLength, (i) => _dot(i)),
                ),
              ),

              const SizedBox(height: 36),

              // Numpad
              GridView.count(crossAxisCount: 3, shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10,
                children: [
                  for (int i = 1; i <= 9; i++) _key(idx: i - 1, digit: '$i'),
                  _key(idx: 9, icon: Icons.backspace_rounded, iconColor: AppColors.error,
                      transparent: true, onTap: () => _onBack(9)),
                  _key(idx: 10, digit: '0'),
                  _key(idx: 11, transparent: true, onTap: () => _onClear(11),
                      child: Text('C', style: GoogleFonts.oswald(
                          fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant))),
                ],
              ),

              const SizedBox(height: 24),
            ]),
          )),

          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: isReady ? _verify : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity, height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    gradient: isReady ? AppGradients.primaryCta : null,
                    color: isReady ? null : AppColors.surfaceContainerHighest,
                    boxShadow: isReady ? AppShadows.primaryGlow : null,
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('دخول الوردية', style: GoogleFonts.oswald(
                        fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.5,
                        color: isReady ? AppColors.onPrimary : AppColors.onSurfaceVariant)),
                    const SizedBox(width: 10),
                    Icon(Icons.login_rounded, size: 20,
                        color: isReady ? AppColors.onPrimary : AppColors.onSurfaceVariant),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: TextButton(
                  onPressed: () {},
                  child: Text('نسيت الرمز السري؟', style: GoogleFonts.nunito(
                      fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)))),
            ]),
          ),
        ])),
      ]),
    );
  }
}

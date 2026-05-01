// ==========================================
// 10. screens/about_us_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_drawer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu, color: AppColors.primary), onPressed: () => Scaffold.of(context).openDrawer())),
        title: Text('BELLA PIZZA', style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.5)),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 40, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('عن المشروع', style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('الإصدار 1.0.4', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('مهمتنا', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Text(
              'تم تصميم نظام بيلا بيتزا لتزويد المطاعم الراقية بنظام إدارة طلبات أنيق وسريع وخالٍ من العيوب. صُمم النظام مع التركيز على تجربة المستخدم وسرعة الأداء.',
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.white70, height: 1.6),
            ),
            const SizedBox(height: 32),
            Text('التطوير', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Text(
              'تم التطوير باستخدام Flutter و Firebase. تم تحسينه لأداء واجهة مستخدم سلس ومزامنة فورية لقواعد البيانات.',
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.white70, height: 1.6),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: -1),
    );
  }
}
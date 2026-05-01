// Navigation drawer used across the app for menu and profile links
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// Stateless app drawer widget
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BELLA',
                    style: GoogleFonts.oswald(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        letterSpacing: 2)),
                Text('PIZZA',
                    style: GoogleFonts.oswald(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary, // Gold
                        letterSpacing: 4)),
              ],
            ),
          ),
          const Divider(color: AppColors.outlineVariant, indent: 32, endIndent: 32),
          const SizedBox(height: 10),
          _buildDrawerItem(
            context: context,
            icon: Icons.local_pizza_rounded,
            label: 'القائمة',
            onTap: () => Navigator.pushReplacementNamed(context, '/menu'),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.info_outline_rounded,
            label: 'من نحن',
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.people_outline_rounded,
            label: 'الموظفين',
            onTap: () => Navigator.of(context).pushNamed('/profile'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(Icons.settings_rounded,
                    color: AppColors.onSurfaceVariant, size: 22),
                title: Text('الإعدادات',
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 0.5)),
                children: [
                  _buildDrawerItem(
                      context: context,
                      icon: Icons.history_rounded,
                      label: 'سجل الطلبات',
                      onTap: () {},
                      isSubItem: true),
                  _buildDrawerItem(
                      context: context,
                      icon: Icons.restaurant_menu_rounded,
                      label: 'محرر القائمة',
                      onTap: () {},
                      isSubItem: true),
                  _buildDrawerItem(
                      context: context,
                      icon: Icons.analytics_outlined,
                      label: 'التحليلات',
                      onTap: () {},
                      isSubItem: true),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildLogoutButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    bool isSubItem = false,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isSubItem ? 32 : 16, vertical: 4),
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                gradient: AppGradients.primaryCta,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppShadows.primaryGlow,
              )
            : null,
        child: ListTile(
          onTap: onTap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(icon,
              color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              size: 22),
          title: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.onPrimary : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceContainerHighest,
          foregroundColor: AppColors.onSurface,
          minimumSize: const Size(double.infinity, 54),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 18),
            const SizedBox(width: 10),
            Text(
              'تسجيل الخروج',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

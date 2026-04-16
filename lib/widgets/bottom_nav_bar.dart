import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

const _kNav = [
  ('الطاولات',  Icons.table_restaurant_rounded, '/tables'),
  ('القائمة',   Icons.local_pizza_rounded,      '/menu'),
  ('الطلبات',   Icons.shopping_bag_rounded,     '/orders'),
  ('الحساب',    Icons.receipt_long_rounded,      '/billing'),
];

class BottomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(height: 64,
          child: Row(children: List.generate(_kNav.length, (i) => Expanded(
            child: _NavBtn(
              label: _kNav[i].$1, icon: _kNav[i].$2,
              isActive: i == currentIndex,
              onTap: () {
                if (onTap != null) { onTap!(i); return; }
                if (i != currentIndex) {
                  Navigator.of(context).pushReplacementNamed(_kNav[i].$3);
                }
              },
            ),
          ))),
        ),
      ),
    ),
  );
}

class _NavBtn extends StatefulWidget {
  final String label; final IconData icon; final bool isActive; final VoidCallback onTap;
  const _NavBtn({required this.label, required this.icon, required this.isActive, required this.onTap});
  @override State<_NavBtn> createState() => _NavBtnState();
}

class _NavBtnState extends State<_NavBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _s = Tween<double>(begin: 1.0, end: 0.88).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () async { await _c.forward(); await _c.reverse(); widget.onTap(); },
    child: ScaleTransition(scale: _s,
      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Active: red circle background; Inactive: plain
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: widget.isActive ? AppColors.primary.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(widget.icon, size: 22,
              color: widget.isActive ? AppColors.primary : AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 3),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w600,
            color: widget.isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            letterSpacing: 0.3),
          child: Text(widget.label)),
      ])),
    ),
  );
}

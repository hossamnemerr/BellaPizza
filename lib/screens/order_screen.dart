// Order screen that displays cart items and quantity controls
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';

// Stateful order list widget
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _qty = {}, _del = {};
  final Map<String, Animation<double>> _qtyS = {}, _delA = {};

  @override
  void dispose() {
    for (final c in [..._qty.values, ..._del.values]) c.dispose();
    super.dispose();
  }

  void _ensure(String id) {
    if (!_qty.containsKey(id)) {
      final c = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 110));
      _qty[id] = c;
      _qtyS[id] = Tween<double>(begin: 1.0, end: 0.78)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }
    if (!_del.containsKey(id)) {
      final c = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 280));
      _del[id] = c;
      _delA[id] = CurvedAnimation(parent: c, curve: Curves.easeIn);
    }
  }

  Future<void> _tapQty(String id, bool add) async {
    HapticFeedback.lightImpact();
    _ensure(id);
    await _qty[id]!.forward();
    await _qty[id]!.reverse();
    if (!mounted) return;
    add
        ? CartProvider.read(context).increment(id)
        : CartProvider.read(context).decrement(id);
  }

  Future<void> _delete(String id) async {
    HapticFeedback.mediumImpact();
    _ensure(id);
    await _del[id]!.forward();
    if (!mounted) return;
    CartProvider.read(context).removeItem(id);
    for (final m in [_qty, _qtyS, _del, _delA]) m.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final items = cart.items;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: Stack(children: [
        items.isEmpty
            ? _empty()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 280),
                physics: const BouncingScrollPhysics(),
                children: [
                  _header(items.length),
                  const SizedBox(height: 20),
                  ...items.map((item) {
                    _ensure(item.id);
                    return _card(item);
                  }),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/menu'),
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.primary, size: 20),
                    label: Text('إضافة المزيد للطلب',
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8)),
                  ),
                ],
              ),
        if (items.isNotEmpty)
          Positioned(left: 0, right: 0, bottom: 0, child: _summary(cart)),
      ]),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Text('BELLA PIZZA',
            style: GoogleFonts.oswald(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: 1.0)),
        centerTitle: true,
      );

  Widget _header(int count) =>
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('الجلسة الحالية',
              style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 2.0)),
          const SizedBox(height: 4),
          Text('طلب العميل',
              style: GoogleFonts.oswald(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.72,
                  height: 1.05)),
        ])),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الأصناف: ${count.toString().padLeft(2, '0')}',
                  style: GoogleFonts.manrope(
                      fontSize: 13, color: AppColors.onSurfaceVariant)),
            ]),
      ]);

  Widget _card(CartItem item) {
    Widget card = Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
                width: 64,
                height: 64,
                child: Image.network(item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceContainerHighest,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.outlineVariant, size: 24))))),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Text(item.name,
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      letterSpacing: -0.14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              if (item.category.isNotEmpty)
                Text(
                    '${item.category}${item.detail.isNotEmpty ? " • ${item.detail}" : ""}',
                    style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 1.2)),
            ])),
        const SizedBox(width: 8),
        _stepper(item),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${item.total.toStringAsFixed(0)} ج',
                  style: GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      letterSpacing: -0.32)),
              if (item.quantity > 1) ...[
                const SizedBox(height: 2),
                Text('${item.unitPrice.toStringAsFixed(0)} ج / قطعة',
                    style: GoogleFonts.manrope(
                        fontSize: 10, color: AppColors.onSurfaceVariant)),
              ],
            ]),
        const SizedBox(width: 4),
        GestureDetector(
            onTap: () => _delete(item.id),
            child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.delete_outline_rounded,
                    color: AppColors.primary, size: 22))),
      ]),
    );

    final delAnim = _delA[item.id];
    if (delAnim != null) {
      card = AnimatedBuilder(
          animation: delAnim,
          builder: (_, child) => Opacity(
              opacity: 1.0 - delAnim.value,
              child: Transform.translate(
                  offset: Offset(60 * delAnim.value, 0), child: child)),
          child: card);
    }
    return card;
  }

  Widget _stepper(CartItem item) {
    final scale = _qtyS[item.id];
    Widget btn(IconData icon, bool isAdd) {
      Widget b = GestureDetector(
          onTap: () => _tapQty(item.id, isAdd),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(icon,
                  size: 16,
                  color: (!isAdd && item.quantity <= 1)
                      ? AppColors.outlineVariant
                      : AppColors.onSurfaceVariant)));
      return scale != null ? ScaleTransition(scale: scale, child: b) : b;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        btn(Icons.remove, false),
        const SizedBox(width: 4),
        SizedBox(
            width: 28,
            child: Text(item.quantity.toString().padLeft(2, '0'),
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white))),
        const SizedBox(width: 4),
        btn(Icons.add, true),
      ]),
    );
  }

  Widget _summary(CartNotifier cart) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: _SCol(
                          'الإجمالي',
                          '${cart.subtotal.toStringAsFixed(0)} ج',
                          AppColors.onSurfaceVariant,
                          20)),
                  Expanded(
                      child: _SCol(
                          'الخدمة 15%',
                          '${cart.service.toStringAsFixed(0)} ج',
                          AppColors.onSurfaceVariant,
                          20)),
                  Expanded(
                      child: _SCol(
                          'الإجمالي الكلي',
                          '${cart.grandTotal.toStringAsFixed(0)} ج',
                          AppColors.primary,
                          24,
                          bold: true)),
                ]),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/billing'),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                        gradient: AppGradients.primaryCta,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppShadows.primaryGlow),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('المتابعة للدفع',
                              style: GoogleFonts.oswald(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.onPrimary,
                                  letterSpacing: 1.0)),
                          const SizedBox(width: 12),
                          const Icon(Icons.arrow_forward_rounded,
                              color: AppColors.onPrimary, size: 20),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );

  Widget _empty() => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.shopping_cart_outlined,
            size: 56, color: AppColors.outlineVariant),
        const SizedBox(height: 16),
        Text('لا توجد طلبات حتى الآن',
            style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        const SizedBox(height: 8),
        Text('أضف أصنافاً من قائمة الطعام',
            style: GoogleFonts.manrope(
                fontSize: 13, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 24),
        GestureDetector(
            onTap: () => Navigator.of(context).pushReplacementNamed('/menu'),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                    gradient: AppGradients.primaryCta,
                    borderRadius: BorderRadius.circular(12)),
                child: Text('تصفح القائمة',
                    style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onPrimary)))),
      ]));
}

class _SCol extends StatelessWidget {
  final String label, value;
  final Color labelColor;
  final double sz;
  final bool bold;
  const _SCol(this.label, this.value, this.labelColor, this.sz,
      {this.bold = false});
  @override
  Widget build(BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    letterSpacing: 1.0)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.manrope(
                    fontSize: sz,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                    height: 1.0)),
          ]);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

void showCustomizeSheet(BuildContext context, {CartItem? prefillItem}) =>
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) => CustomizeSheet(prefillItem: prefillItem),
    );

class _Option {
  final String label;
  final double price;
  bool on;
  _Option(this.label, {this.price = 0, this.on = false});
}

class CustomizeSheet extends StatefulWidget {
  final CartItem? prefillItem;
  const CustomizeSheet({super.key, this.prefillItem});
  @override State<CustomizeSheet> createState() => _CustomizeSheetState();
}

class _CustomizeSheetState extends State<CustomizeSheet> with TickerProviderStateMixin {
  int _qty = 1;

  // Pizza-specific toppings
  final _toppings = [
    _Option('جبنة إضافية', price: 20, on: true),
    _Option('بيبروني', price: 25),
    _Option('فطر', price: 15),
    _Option('زيتون', price: 10),
    _Option('فلفل حلو', price: 15),
    _Option('صوص حار', price: 5),
  ];

  // Pizza dietary
  final _dietary = [
    _Option('بدون بصل'),
    _Option('عجينة كريسبي'),
    _Option('بدون ثوم'),
  ];

  late final AnimationController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    if (widget.prefillItem != null) _qty = widget.prefillItem!.quantity;
  }
  @override void dispose() { _qtyCtrl.dispose(); super.dispose(); }

  Future<void> _bump() async { await _qtyCtrl.forward(); await _qtyCtrl.reverse(); }

  double get _total {
    final base = widget.prefillItem?.unitPrice ?? 0;
    final extras = _toppings.where((t) => t.on).fold(0.0, (s, t) => s + t.price);
    return (base + extras) * _qty;
  }

  void _addToOrder() {
    HapticFeedback.mediumImpact();
    final base = widget.prefillItem?.unitPrice ?? 0;
    final extras = _toppings.where((t) => t.on).fold(0.0, (s, t) => s + t.price);
    CartProvider.read(context).addItem(CartItem(
      id: widget.prefillItem?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: widget.prefillItem?.name ?? 'Custom Pizza',
      category: widget.prefillItem?.category ?? 'PIZZA',
      description: widget.prefillItem?.description ?? '',
      detail: _toppings.where((t) => t.on).map((t) => t.label).join(', '),
      imageUrl: widget.prefillItem?.imageUrl ?? '',
      unitPrice: base + extras,
      quantity: _qty,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.4), width: 2)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Drag handle
        Padding(padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Center(child: Container(width: 44, height: 5,
            decoration: BoxDecoration(color: AppColors.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3))))),
        // Header
        Padding(padding: const EdgeInsets.fromLTRB(20, 8, 12, 16), child: Row(children: [
          Text('تخصيص الطلب', style: GoogleFonts.oswald(
              fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.onSurface, letterSpacing: 0.3)),
          const Spacer(),
          GestureDetector(onTap: () => Navigator.of(context).pop(),
            child: Container(width: 38, height: 38,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: AppColors.surfaceContainerHighest,
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
              child: const Icon(Icons.close_rounded, color: AppColors.onSurface, size: 20))),
        ])),
        // Scrollable body
        Flexible(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 0, 20, inset + 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Hero
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(borderRadius: BorderRadius.circular(14),
                child: SizedBox(width: 96, height: 96,
                  child: Image.network(widget.prefillItem?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surfaceContainerHighest,
                      child: const Icon(Icons.local_pizza_rounded,
                          color: AppColors.outlineVariant, size: 36))))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.prefillItem?.name ?? 'Item', style: GoogleFonts.oswald(
                    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                const SizedBox(height: 6),
                Text(widget.prefillItem?.description ?? '', style: GoogleFonts.nunito(
                    fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5)),
                const SizedBox(height: 8),
                Text('السعر الأساسي: ${(widget.prefillItem?.unitPrice ?? 0).toStringAsFixed(0)} ج',
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700,
                      color: AppColors.gold)),
              ])),
            ]),

            const SizedBox(height: 28),

            // Toppings section
            Row(children: [
              Container(width: 3, height: 14,
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text('إضافات البيتزا', style: GoogleFonts.oswald(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface, letterSpacing: 0.5)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
                child: Text('اختياري', style: GoogleFonts.nunito(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant, letterSpacing: 0.5))),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: _toppings.map((t) => GestureDetector(
              onTap: () { HapticFeedback.selectionClick(); setState(() => t.on = !t.on); },
              child: AnimatedContainer(duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: t.on ? AppGradients.primaryCta : null,
                  color: t.on ? null : AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: t.on ? null : Border.all(
                      color: AppColors.outlineVariant.withOpacity(0.5), width: 1),
                  boxShadow: t.on ? [BoxShadow(color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 10, offset: const Offset(0, 3))] : null),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(t.on ? Icons.check_circle_rounded : Icons.add_rounded,
                      size: 15, color: t.on ? AppColors.onPrimary : AppColors.onSurfaceVariant),
                  const SizedBox(width: 7),
                  Text(t.label, style: GoogleFonts.nunito(fontSize: 13,
                      fontWeight: t.on ? FontWeight.w800 : FontWeight.w600,
                      color: t.on ? AppColors.onPrimary : AppColors.onSurface)),
                  if (t.price > 0) ...[
                    const SizedBox(width: 6),
                    Text('+${t.price.toStringAsFixed(0)} ج', style: GoogleFonts.nunito(
                        fontSize: 11, fontWeight: FontWeight.w800,
                        color: t.on ? AppColors.onPrimary.withOpacity(0.8) : AppColors.gold)),
                  ],
                ]),
              ),
            )).toList()),

            const SizedBox(height: 28),

            // Dietary notes
            Row(children: [
              Container(width: 3, height: 14,
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text('ملاحظات خاصة', style: GoogleFonts.oswald(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface, letterSpacing: 0.5)),
            ]),
            const SizedBox(height: 10),
            ..._dietary.asMap().entries.map((e) => Padding(
              padding: EdgeInsets.only(bottom: e.key < _dietary.length - 1 ? 10 : 0),
              child: GestureDetector(
                onTap: () { HapticFeedback.selectionClick(); setState(() => e.value.on = !e.value.on); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: e.value.on ? AppColors.primary.withOpacity(0.5) : AppColors.outlineVariant.withOpacity(0.4),
                      width: e.value.on ? 1.5 : 1),
                  ),
                  child: Row(children: [
                    Text(e.value.label, style: GoogleFonts.nunito(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                    const Spacer(),
                    AnimatedContainer(duration: const Duration(milliseconds: 200),
                      width: 22, height: 22,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: e.value.on ? AppColors.primary : Colors.transparent,
                        border: e.value.on ? null : Border.all(
                            color: AppColors.outline.withOpacity(0.6), width: 2),
                        boxShadow: e.value.on ? [BoxShadow(
                            color: AppColors.primary.withOpacity(0.35), blurRadius: 8)] : null),
                      child: e.value.on ? const Icon(Icons.check_rounded,
                          size: 14, color: AppColors.onPrimary) : null),
                  ]),
                ),
              ),
            )),

            const SizedBox(height: 28),

            // Special instructions
            Row(children: [
              Container(width: 3, height: 14,
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text('تعليمات خاصة', style: GoogleFonts.oswald(
                  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface, letterSpacing: 0.5)),
            ]),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4), width: 1)),
              child: TextFormField(
                minLines: 3, maxLines: 5,
                style: GoogleFonts.nunito(fontSize: 14, color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'مثال: عجينة سميكة، بدون ملح زيادة...',
                  filled: false,
                  hintStyle: GoogleFonts.nunito(fontSize: 13, color: AppColors.outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.gold.withOpacity(0.5), width: 2)),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        )),
        // Footer
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            border: Border(top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)))),
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + inset),
          child: Row(children: [
            // Qty stepper
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                _QtyBtn(icon: Icons.remove_rounded, enabled: _qty > 1,
                    onTap: () async { if (_qty <= 1) return; await _bump(); setState(() => _qty--); }),
                SizedBox(width: 34, child: Text('$_qty', textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w600,
                      color: AppColors.onSurface))),
                _QtyBtn(icon: Icons.add_rounded, enabled: true,
                    onTap: () async { await _bump(); setState(() => _qty++); }),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(child: _AddBtn(price: _total, onTap: _addToOrder)),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  SUB-WIDGETS
// ─────────────────────────────────────────────

class _QtyBtn extends StatefulWidget {
  final IconData icon; final bool enabled; final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.enabled, required this.onTap});
  @override State<_QtyBtn> createState() => _QtyBtnState();
}
class _QtyBtnState extends State<_QtyBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: 0.78).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _s,
    child: GestureDetector(
      onTap: () async { if (!widget.enabled) return; await _c.forward(); await _c.reverse(); widget.onTap(); },
      child: SizedBox(width: 40, height: 40,
        child: Icon(widget.icon, size: 22,
          color: widget.enabled ? AppColors.primary : AppColors.outlineVariant))));
}

class _AddBtn extends StatefulWidget {
  final double price; final VoidCallback onTap;
  const _AddBtn({required this.price, required this.onTap});
  @override State<_AddBtn> createState() => _AddBtnState();
}
class _AddBtnState extends State<_AddBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override void initState() { super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _s = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _s,
    child: GestureDetector(
      onTap: () async { await _c.forward(); await _c.reverse(); widget.onTap(); },
      onTapDown: (_) => _c.forward(), onTapUp: (_) => _c.reverse(), onTapCancel: () => _c.reverse(),
      child: Container(height: 58,
        decoration: BoxDecoration(
          gradient: AppGradients.primaryCta,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: AppShadows.primaryGlow),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('أضف للطلب', style: GoogleFonts.oswald(
              fontSize: 17, fontWeight: FontWeight.w600,
              color: AppColors.onPrimary, letterSpacing: 0.5)),
          const Spacer(),
          Text('${widget.price.toStringAsFixed(0)} ج', style: GoogleFonts.oswald(
              fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.onPrimary)),
        ]))));
}

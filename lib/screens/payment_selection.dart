// ==========================================
// screens/payment_selection_screen.dart
// ==========================================
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({super.key});
  @override State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String _selectedMethod = 'بطاقة ائتمان';

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final total = cart.grandTotal;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('BELLA PIZZA', 
          style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.5)),
        actions: [
          Center(child: Text('طلب رقم #${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}', 
            style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w700))),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('إتمام الدفع بأمان', 
                    style: GoogleFonts.oswald(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Text('إجمالي المبلغ المستحق:\n${total.toStringAsFixed(0)} ج', 
                    style: GoogleFonts.oswald(fontSize: 42, fontWeight: FontWeight.w800, color: AppColors.onSurface, height: 1.1)),

                  const SizedBox(height: 32),
                  _buildMethodCard('نقداً', 'الدفع عند الاستلام', Icons.payments_rounded),
                  const SizedBox(height: 12),
                  _buildMethodCard('بطاقة ائتمان', 'فيزا، ماستركارد، أميكس', Icons.credit_card_rounded),
                  const SizedBox(height: 12),
                  _buildMethodCard('أبل باي', 'دفع سريع عبر الهاتف', Icons.contactless_rounded),

                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow, 
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ملخص الفاتورة', 
                          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant, letterSpacing: 1.5)),
                        const SizedBox(height: 16),
                        _buildSummaryRow('الإجمالي الفرعي', '${cart.subtotal.toStringAsFixed(0)} ج'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('رسوم الخدمة (15%)', '${cart.service.toStringAsFixed(0)} ج'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: GestureDetector(
              onTap: () {
                if (total > 0) {
                  Navigator.of(context).pushNamed('/payment-success');
                }
              },
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryCta,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.primaryGlow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تأكيد عملية الدفع', 
                      style: GoogleFonts.oswald(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.onPrimary)),
                    const SizedBox(width: 12),
                    const Icon(Icons.check_circle_outline_rounded, color: AppColors.onPrimary, size: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildMethodCard(String title, String subtitle, IconData icon) {
    bool isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.5) : Colors.transparent,
            width: 1.5
          )
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(14)
              ),
              child: Icon(icon, color: isSelected ? AppColors.onPrimary : AppColors.primary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.oswald(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.nunito(fontSize: 11, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24)
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w500)),
        Text(value, style: GoogleFonts.oswald(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

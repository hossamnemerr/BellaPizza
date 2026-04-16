import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/customize_sheet.dart';

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class MenuCategory {
  final String id, label;
  final IconData icon;
  const MenuCategory({required this.id, required this.label, required this.icon});
}

class MenuItem {
  final String id, name, description, imageUrl, categoryId;
  final double price;
  final List<String> chips;
  final bool isFeatured;
  const MenuItem({
    required this.id, required this.name, required this.description,
    required this.imageUrl, required this.categoryId, required this.price,
    this.chips = const [], this.isFeatured = false,
  });
}

// ─────────────────────────────────────────────
//  PIZZA MENU DATA
// ─────────────────────────────────────────────

const List<MenuCategory> kCategories = [
  MenuCategory(id: 'all',       label: 'الكل',         icon: Icons.grid_view_rounded),
  MenuCategory(id: 'classic',   label: 'بيتزا كلاسيك', icon: Icons.local_pizza_rounded),
  MenuCategory(id: 'special',   label: 'سبيشال',       icon: Icons.star_rounded),
  MenuCategory(id: 'pasta',     label: 'باستا',        icon: Icons.ramen_dining_rounded),
  MenuCategory(id: 'sides',     label: 'مقبلات',       icon: Icons.tapas_rounded),
  MenuCategory(id: 'drinks',    label: 'مشروبات',      icon: Icons.local_drink_rounded),
  MenuCategory(id: 'desserts',  label: 'حلويات',       icon: Icons.cake_rounded),
];

const List<MenuItem> kMenuItems = [
  // ── Featured ──────────────────────────────
  MenuItem(
    id: 'supreme_special',
    name: 'سوبريم سبيشال',
    description: 'بيتزا بالجبنة الرباعية، اللحم المفروم، الفطر، والفلفل الملون.',
    price: 185.00,
    imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
    categoryId: 'special', chips: ['الأكثر طلباً', 'جديد'], isFeatured: true,
  ),
  // ── Classic ───────────────────────────────
  MenuItem(
    id: 'margherita',
    name: 'مارغريتا',
    description: 'صوص طماطم طازج، موزاريلا، وريحان.',
    price: 120.00,
    imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&q=80',
    categoryId: 'classic', chips: ['نباتي', 'كلاسيك'],
  ),
  MenuItem(
    id: 'pepperoni',
    name: 'بيبروني',
    description: 'بيبروني مقرمش على طبقة سميكة من الجبنة.',
    price: 145.00,
    imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&q=80',
    categoryId: 'classic', chips: ['الأكثر مبيعاً'],
  ),
  MenuItem(
    id: 'bbq_chicken',
    name: 'دجاج باربيكيو',
    description: 'دجاج مشوي بصوص الباربيكيو والبصل المكرمل.',
    price: 155.00,
    imageUrl: 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?w=400&q=80',
    categoryId: 'classic', chips: ['مدخن'],
  ),
  // ── Special ───────────────────────────────
  MenuItem(
    id: 'four_cheese',
    name: 'أربعة جبن',
    description: 'موزاريلا، جودة، ريكوتا، وبارميزان.',
    price: 175.00,
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80',
    categoryId: 'special', chips: ['طباخ الشيف'],
  ),
  MenuItem(
    id: 'meat_lovers',
    name: 'محبو اللحوم',
    description: 'لحم مفروم، بيبروني، سجق، ولحم مدخن.',
    price: 200.00,
    imageUrl: 'https://images.unsplash.com/photo-1594007654729-407eedc4be65?w=400&q=80',
    categoryId: 'special', chips: ['مميز', 'ضخم'],
  ),
  MenuItem(
    id: 'truffle_pizza',
    name: 'بيتزا التروفل',
    description: 'كريمة التروفل، جبنة البارميزان، والفطر الأسود.',
    price: 240.00,
    imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91798d792b?w=400&q=80',
    categoryId: 'special', chips: ['فاخر'],
  ),
  // ── Pasta ─────────────────────────────────
  MenuItem(
    id: 'carbonara',
    name: 'كاربونارا',
    description: 'سباغيتي بصوص كريمة، بيكون، وبارميزان.',
    price: 130.00,
    imageUrl: 'https://images.unsplash.com/photo-1608756687911-aa1599ab3bd9?w=400&q=80',
    categoryId: 'pasta', chips: ['كلاسيك إيطالي'],
  ),
  MenuItem(
    id: 'arrabiata',
    name: 'أرابياتا',
    description: 'صوص طماطم حار بالثوم والفلفل الأحمر.',
    price: 110.00,
    imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&q=80',
    categoryId: 'pasta', chips: ['حار'],
  ),
  MenuItem(
    id: 'pesto_pasta',
    name: 'باستا بيستو',
    description: 'فيتوتشيني بصوص الريحان والصنوبر.',
    price: 125.00,
    imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400&q=80',
    categoryId: 'pasta', chips: ['نباتي'],
  ),
  // ── Sides ─────────────────────────────────
  MenuItem(
    id: 'garlic_bread',
    name: 'خبز بالثوم',
    description: 'خبز فرنسي مقرمش بزبدة الثوم والأعشاب.',
    price: 65.00,
    imageUrl: 'https://images.unsplash.com/photo-1619881589316-3f0c7a67d0a1?w=400&q=80',
    categoryId: 'sides',
  ),
  MenuItem(
    id: 'mozzarella_sticks',
    name: 'عيدان موزاريلا',
    description: '6 عيدان موزاريلا مقلية مع صوص الطماطم.',
    price: 85.00,
    imageUrl: 'https://images.unsplash.com/photo-1548340748-6d2b7d7da280?w=400&q=80',
    categoryId: 'sides', chips: ['مشهور'],
  ),
  MenuItem(
    id: 'caesar_salad',
    name: 'سلطة قيصر',
    description: 'خس روماني، صوص قيصر، بارميزان، وكروتون.',
    price: 80.00,
    imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&q=80',
    categoryId: 'sides',
  ),
  // ── Drinks ────────────────────────────────
  MenuItem(
    id: 'lemonade',
    name: 'ليمونادة طازجة',
    description: 'ليمون طازج بالنعناع والشراب.',
    price: 55.00,
    imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&q=80',
    categoryId: 'drinks', chips: ['منعش'],
  ),
  MenuItem(
    id: 'iced_tea',
    name: 'شاي مثلج',
    description: 'شاي أسود بارد مع الليمون والنعناع.',
    price: 50.00,
    imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&q=80',
    categoryId: 'drinks',
  ),
  MenuItem(
    id: 'orange_juice',
    name: 'عصير برتقال',
    description: 'برتقال طازج معصور.',
    price: 65.00,
    imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&q=80',
    categoryId: 'drinks', chips: ['طازج'],
  ),
  // ── Desserts ──────────────────────────────
  MenuItem(
    id: 'tiramisu',
    name: 'تيراميسو',
    description: 'كريمة المسكربوني، اسبريسو، وكاكاو.',
    price: 95.00,
    imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&q=80',
    categoryId: 'desserts', chips: ['إيطالي أصيل'],
  ),
  MenuItem(
    id: 'brownie',
    name: 'براوني شوكولاتة',
    description: 'براوني دافئ مع آيس كريم فانيلا.',
    price: 85.00,
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&q=80',
    categoryId: 'desserts', chips: ['ساخن'],
  ),
  MenuItem(
    id: 'panna_cotta',
    name: 'بانا كوتا',
    description: 'كريمة إيطالية بصوص التوت الأحمر.',
    price: 90.00,
    imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&q=80',
    categoryId: 'desserts',
  ),
];

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _selCat = 0;
  String? _lastAddedItem;
  bool _showTopNotif = false;

  List<MenuItem> get _visible {
    final cat = kCategories[_selCat];
    final nf = kMenuItems.where((m) => !m.isFeatured);
    if (cat.id == 'all') {
      return nf.toList();
    }
    return nf.where((m) => m.categoryId == cat.id).toList();
  }

  final Map<String, AnimationController> _addCtrls = {};
  final Map<String, Animation<double>> _addScales = {};

  @override
  void initState() {
    super.initState();
    for (final item in kMenuItems) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 130));
      _addCtrls[item.id] = c;
      _addScales[item.id] = Tween<double>(begin: 1.0, end: 0.84)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    for (final c in _addCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _openSheet(MenuItem item) => showCustomizeSheet(context, prefillItem: CartItem(
    id: item.id, name: item.name,
    category: item.categoryId.toUpperCase(),
    description: item.description,
    detail: item.chips.isNotEmpty ? item.chips.first : '',
    imageUrl: item.imageUrl, unitPrice: item.price,
  ));

  Future<void> _quickAdd(MenuItem item) async {
    HapticFeedback.lightImpact();
    final ctrl = _addCtrls[item.id];
    if (ctrl != null) {
      await ctrl.forward();
      await ctrl.reverse();
    }
    if (!mounted) return;
    CartProvider.read(context).addItem(CartItem(
      id: item.id, name: item.name,
      category: item.categoryId.toUpperCase(),
      description: item.description,
      detail: item.chips.isNotEmpty ? item.chips.first : '',
      imageUrl: item.imageUrl, unitPrice: item.price,
    ));
    if (mounted) {
      setState(() {
        _lastAddedItem = item.name;
        _showTopNotif = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showTopNotif = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: _appBar(cart.totalCount),
      body: Stack(children: [
        CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverToBoxAdapter(child: _categoryRow()),
          SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _featuredCard(kMenuItems.first))),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            child: Row(children: [
              Container(width: 3, height: 16,
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(_selCat == 0 ? 'القائمة كاملة' : kCategories[_selCat].label,
                style: GoogleFonts.oswald(fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.onSurface, letterSpacing: 0.8)),
            ]),
          )),
          _visible.isEmpty
              ? SliverToBoxAdapter(child: _emptyState())
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList.separated(
                    itemCount: _visible.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => _itemCard(_visible[i]))),
        ]),
        // Bottom-aligned Notification (Above Nav Bar)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          bottom: _showTopNotif ? 62 : -100,
          left: 16, right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest.withOpacity(0.95),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text('تم إضافة $_lastAddedItem لطلبك', style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
              ),
            ]),
          ),
        ),
      ]),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _appBar(int count) => AppBar(
    backgroundColor: AppColors.background, elevation: 0, scrolledUnderElevation: 0,
    automaticallyImplyLeading: false, titleSpacing: 16,
    title: Row(children: [
      const Icon(Icons.local_pizza_rounded, color: AppColors.primary, size: 24),
      const SizedBox(width: 10),
      Text('SLICE PIZZA', style: GoogleFonts.oswald(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface, letterSpacing: 1.5)),
    ]),
    actions: [
      Stack(clipBehavior: Clip.none, children: [
        IconButton(icon: const Icon(Icons.shopping_bag_rounded, color: AppColors.onSurface, size: 26),
            onPressed: () => Navigator.of(context).pushNamed('/orders')),
        if (count > 0) Positioned(top: 6, right: 6,
          child: Container(width: 16, height: 16,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Center(child: Text('$count', style: GoogleFonts.nunito(
                fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onPrimary))))),
      ]),
      Padding(padding: const EdgeInsets.only(right: 14),
        child: Container(width: 36, height: 36,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
          child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 20))),
    ],
  );

  Widget _categoryRow() => SizedBox(height: 52,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: kCategories.length,
      separatorBuilder: (context, index) => const SizedBox(width: 8),
      itemBuilder: (context, i) {
        final cat = kCategories[i];
        final isActive = i == _selCat;
        return GestureDetector(
          onTap: () => setState(() => _selCat = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: isActive ? AppGradients.primaryCta : null,
              color: isActive ? null : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
              border: isActive ? null : Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.4), width: 1),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(cat.icon, size: 15,
                  color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant),
              const SizedBox(width: 7),
              Text(cat.label, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.onPrimary : AppColors.onSurface)),
            ]),
          ),
        );
      },
    ),
  );

  Widget _featuredCard(MenuItem item) => GestureDetector(
    onTap: () => _openSheet(item),
    child: ClipRRect(borderRadius: BorderRadius.circular(AppRadius.card),
      child: SizedBox(width: double.infinity, height: 210,
        child: Stack(fit: StackFit.expand, children: [
          Image.network(item.imageUrl, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surfaceContainerHigh)),
          // Dark gradient overlay
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topRight, end: Alignment.bottomLeft,
              colors: [Color(0x00000000), Color(0xDD120C04)], stops: [0.2, 1.0]))),
          Padding(padding: const EdgeInsets.all(20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tags
              Wrap(spacing: 6, children: item.chips.map((c) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(c, style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w800,
                    color: AppColors.onPrimary, letterSpacing: 0.5)))).toList()),
              const SizedBox(height: 8),
              Text(item.name, style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.w600,
                  color: AppColors.onSurface, letterSpacing: 0.3, height: 1.1)),
              const SizedBox(height: 4),
              Text(item.description, style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(children: [
                Text('${item.price.toStringAsFixed(0)} ج', style: GoogleFonts.oswald(
                    fontSize: 26, fontWeight: FontWeight.w600,
                    color: AppColors.gold, letterSpacing: 0.3)),
                const Spacer(),
                GestureDetector(onTap: () => _quickAdd(item),
                  child: Container(width: 42, height: 42,
                    decoration: const BoxDecoration(shape: BoxShape.circle,
                        gradient: AppGradients.primaryCta),
                    child: const Icon(Icons.add_rounded, color: AppColors.onPrimary, size: 24))),
              ]),
            ],
          )),
        ])),
    ),
  );

  Widget _itemCard(MenuItem item) {
    final scale = _addScales[item.id];
    return GestureDetector(
      onTap: () => _openSheet(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4), width: 1),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Image
          ClipRRect(borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: 68, height: 68,
              child: Image.network(item.imageUrl, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: AppColors.surfaceContainerHighest,
                  child: const Icon(Icons.local_pizza_rounded, color: AppColors.outlineVariant))))),
          const SizedBox(width: 12),
          // Info
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(item.name, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800,
                color: AppColors.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(item.description, style: GoogleFonts.nunito(fontSize: 12,
                color: AppColors.onSurfaceVariant, height: 1.35),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            if (item.chips.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(spacing: 5, runSpacing: 4, children: item.chips.map((c) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)),
                child: Text(c, style: GoogleFonts.nunito(fontSize: 9, fontWeight: FontWeight.w700,
                    color: AppColors.primary, letterSpacing: 0.3)))).toList()),
            ],
          ])),
          const SizedBox(width: 10),
          // Price + add
          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${item.price.toStringAsFixed(0)} ج', style: GoogleFonts.oswald(fontSize: 17,
                fontWeight: FontWeight.w600, color: AppColors.gold, letterSpacing: 0.3)),
            const SizedBox(height: 8),
            scale != null
                ? ScaleTransition(scale: scale,
                    child: GestureDetector(onTap: () => _quickAdd(item),
                        behavior: HitTestBehavior.opaque, child: _AddBtn()))
                : GestureDetector(onTap: () => _quickAdd(item),
                    behavior: HitTestBehavior.opaque, child: _AddBtn()),
          ]),
        ]),
      ),
    );
  }

  Widget _emptyState() => Padding(padding: const EdgeInsets.symmetric(vertical: 60),
    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.search_off_rounded, size: 40, color: AppColors.outlineVariant),
      const SizedBox(height: 12),
      Text('لا توجد عناصر في هذا القسم',
          style: GoogleFonts.nunito(fontSize: 13, color: AppColors.onSurfaceVariant)),
    ])));
}

class _AddBtn extends StatelessWidget {
  const _AddBtn();
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1)),
    child: const Icon(Icons.add_rounded, color: AppColors.gold, size: 20));
}

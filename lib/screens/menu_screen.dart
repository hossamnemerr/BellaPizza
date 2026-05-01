// Menu screen that loads menu items from Firestore and shows cart options
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/cart_provider.dart';
import '../models/menu_models.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/customize_sheet.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/category_selector.dart';

// Stateful widget for the main menu page
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

// State implementation for MenuScreen
class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'all';

  void _openSheetFromFirebase(Map<String, dynamic> data, String id) {
    final menuItem = MenuItem.fromMap(id, data);
    showCustomizeSheet(context, prefillItem: _toCartItem(menuItem));
  }

  CartItem _toCartItem(MenuItem m) => CartItem(
        id: m.id,
        name: m.name,
        category: m.categoryId.toUpperCase(),
        description: m.description,
        detail: m.chips.isNotEmpty ? m.chips.first : '',
        imageUrl: m.imageUrl,
        unitPrice: m.price,
      );

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      drawer: const AppDrawer(),
      appBar: _buildAppBar(cart.totalCount),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(
                child: Text('خطأ في الاتصال بالقاعدة',
                    style: TextStyle(color: Colors.white)));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          final allDocs = snapshot.data!.docs;
          if (allDocs.isEmpty) return _buildEmptyState();

          final allItems = allDocs
              .map((doc) =>
                  MenuItem.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          final dynamicCategories =
              MenuUtils.generateDynamicCategories(allItems);
          final filteredItems = _selectedCategory == 'all'
              ? allItems
              : allItems
                  .where((item) => item.categoryId == _selectedCategory)
                  .toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: CategorySelector(
                  categories: dynamicCategories,
                  selectedId: _selectedCategory,
                  onSelect: (id) => setState(() => _selectedCategory = id),
                ),
              ),
              SliverToBoxAdapter(child: _buildSectionTitle(_selectedCategory)),
              filteredItems.isEmpty
                  ? _buildEmptyState()
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      sliver: SliverList.separated(
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final item = filteredItems[i];
                          return MenuItemCard(
                            item: item,
                            onTap: () => _openSheetFromFirebase(
                                allDocs
                                    .firstWhere((d) => d.id == item.id)
                                    .data() as Map<String, dynamic>,
                                item.id),
                            onAdd: () {
                              HapticFeedback.mediumImpact();
                              CartProvider.read(context)
                                  .addItem(_toCartItem(item));
                              _showSuccessSnackBar(item.name);
                            },
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildSectionTitle(String categoryId) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 16, 12),
      child: Text(
        categoryId == 'all' ? 'القائمة الكاملة' : categoryId.toUpperCase(),
        style: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primary, // Now Gold
            letterSpacing: 1.2),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int count) => AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded,
                      color: AppColors.primary, size: 28), // Now Gold
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )),
        title: Text('BELLA PIZZA',
            style: GoogleFonts.oswald(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary, // Now Gold
                letterSpacing: 1.0)),
        centerTitle: true,
        actions: [_buildCartBtn(count), const SizedBox(width: 8)],
      );

  Widget _buildEmptyState() => SliverToBoxAdapter(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Center(
              child: Column(
            children: [
              const Icon(Icons.search_off_rounded,
                  color: AppColors.outlineVariant, size: 48),
              const SizedBox(height: 16),
              Text('لا توجد أصناف حالياً',
                  style: GoogleFonts.nunito(
                      color: AppColors.onSurfaceVariant, fontSize: 16)),
            ],
          ))));

  Widget _buildCartBtn(int count) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: IconButton(
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text(count.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            backgroundColor: AppColors.primary,
            textColor: AppColors.onPrimary,
            child: const Icon(Icons.shopping_bag_outlined,
                color: AppColors.onSurface, size: 26),
          ),
          onPressed: () => Navigator.of(context).pushNamed('/orders'),
        ),
      );

  void _showSuccessSnackBar(String name) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.onPrimary, size: 20),
          const SizedBox(width: 12),
          Text('$name أُضيف للطلب',
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        ],
      ),
      backgroundColor: AppColors.primary,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    ));
  }
}

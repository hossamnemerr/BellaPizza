import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  COLOR TOKENS  — Pizza theme: Warm Black + Crimson + Gold
// ─────────────────────────────────────────────
abstract final class AppColors {
  // Backgrounds — warm charcoal, not cold grey
  static const background              = Color(0xFF1A1008); // warm espresso black
  static const surface                 = Color(0xFF120C04); // deepest warm black
  static const surfaceContainerLow    = Color(0xFF1F1408); // card base
  static const surfaceContainer       = Color(0xFF261A0C); // mid container
  static const surfaceContainerHigh   = Color(0xFF2E2010); // card elevated
  static const surfaceContainerHighest = Color(0xFF3A2A18); // tooltip/chip bg

  // Primary — Crimson Red (pizza sauce)
  static const primary                = Color(0xFFFF3B2F); // vivid crimson
  static const primaryDim             = Color(0xFFE02C22); // slightly muted
  static const primaryContainer       = Color(0xFF8B1A12); // deep tomato
  static const onPrimary              = Color(0xFFFFFFFF); // white on red

  // Accent — Gold / Cheese yellow
  static const gold                   = Color(0xFFFFB930); // melted cheese gold
  static const goldDim                = Color(0xFFE0A020); // darker gold
  static const onGold                 = Color(0xFF2A1800); // dark text on gold

  // Secondary — warm beige
  static const secondary              = Color(0xFFFFDDA0); // crust beige
  static const secondaryContainer     = Color(0xFF5C3A1A); // deep brown
  static const onSecondary            = Color(0xFF2A1800);

  // On-colors
  static const onSurface              = Color(0xFFFFF5E6); // warm white
  static const onSurfaceVariant       = Color(0xFFB89878); // muted warm beige
  static const onBackground           = Color(0xFFFFF5E6);

  // Outline
  static const outline                = Color(0xFF6B4F30); // warm brown outline
  static const outlineVariant         = Color(0xFF3D2810); // subtle divider

  // Error
  static const error                  = Color(0xFFFF6B4A);
  static const onError                = Color(0xFF4A0A00);
  static const errorContainer         = Color(0xFF7A1C0C);
  static const onErrorContainer       = Color(0xFFFFB4AB);

  // Misc
  static const inverseSurface         = Color(0xFFFFF5E6);
  static const inverseOnSurface       = Color(0xFF2A1800);
  static const inversePrimary         = Color(0xFF8B1A12);
}

abstract final class AppGradients {
  // Primary CTA — red to deep red
  static const primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );

  // Gold CTA — for featured items
  static const goldCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gold, AppColors.goldDim],
  );

  // Warm background glow
  static const backgroundGlow = RadialGradient(
    center: Alignment.topRight,
    radius: 1.4,
    colors: [Color(0x18FF3B2F), Color(0x00000000)],
  );
}

abstract final class AppShadows {
  static const floatingBar = [BoxShadow(color: Color(0xCC000000), blurRadius: 32, offset: Offset(0, -8))];
  static const primaryGlow = [BoxShadow(color: Color(0x55FF3B2F), blurRadius: 24, offset: Offset(0, 8))];
  static const goldGlow    = [BoxShadow(color: Color(0x55FFB930), blurRadius: 24, offset: Offset(0, 8))];
  static const modal       = [BoxShadow(color: Color(0x99000000), blurRadius: 32, offset: Offset(0, 12))];
}

abstract final class AppRadius {
  static const double card   = 16;
  static const double button = 10;
  static const double chip   = 8;
  static const double sheet  = 28;
  static final cardAll   = BorderRadius.circular(card);
  static final buttonAll = BorderRadius.circular(button);
  static final chipAll   = BorderRadius.circular(chip);
  static final sheetTop  = const BorderRadius.vertical(top: Radius.circular(sheet));
}

abstract final class AppTheme {
  static ThemeData get dark {
    // Pizza branding uses Oswald (bold display) + Nunito (body)
    TextStyle display(double sz, FontWeight w, {double ls = 0}) =>
        GoogleFonts.oswald(fontSize: sz, fontWeight: w, letterSpacing: ls, color: AppColors.onSurface);
    TextStyle body(double sz, FontWeight w, {double ls = 0}) =>
        GoogleFonts.nunito(fontSize: sz, fontWeight: w, letterSpacing: ls, color: AppColors.onSurface);

    final tt = TextTheme(
      displayLarge:   display(57, FontWeight.w700, ls: -1.0),
      displayMedium:  display(45, FontWeight.w700, ls: -0.8),
      displaySmall:   display(36, FontWeight.w700, ls: -0.6),
      headlineLarge:  display(40, FontWeight.w700, ls: -0.8),
      headlineMedium: display(28, FontWeight.w700, ls: -0.5),
      headlineSmall:  display(24, FontWeight.w600, ls: -0.3),
      titleLarge:     body(20, FontWeight.w800, ls: -0.2),
      titleMedium:    body(16, FontWeight.w700),
      titleSmall:     body(14, FontWeight.w700),
      bodyLarge:      body(16, FontWeight.w500),
      bodyMedium:     body(14, FontWeight.w400),
      bodySmall:      body(12, FontWeight.w400),
      labelLarge:     body(12, FontWeight.w800, ls: 1.0),
      labelMedium:    body(10, FontWeight.w700, ls: 1.4),
      labelSmall:     body(9,  FontWeight.w700, ls: 1.8),
    );

    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,          onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer, onPrimaryContainer: Color(0xFFFFDAD5),
      secondary: AppColors.secondary,      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer, onSecondaryContainer: Color(0xFFFFDDB0),
      tertiary: AppColors.gold,            onTertiary: AppColors.onGold,
      tertiaryContainer: AppColors.goldDim, onTertiaryContainer: Color(0xFF2A1800),
      error: AppColors.error,              onError: AppColors.onError,
      errorContainer: AppColors.errorContainer, onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,          onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      surfaceContainerHigh:    AppColors.surfaceContainerHigh,
      surfaceContainer:        AppColors.surfaceContainer,
      surfaceContainerLow:     AppColors.surfaceContainerLow,
      surfaceContainerLowest:  Color(0xFF0A0600),
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
      scrim: Color(0xFF000000),
      shadow: Color(0xFF000000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      splashColor: AppColors.primary.withOpacity(0.08),
      highlightColor: AppColors.primary.withOpacity(0.05),
      splashFactory: InkRipple.splashFactory,
      textTheme: tt, primaryTextTheme: tt,
      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant, size: 24),
      primaryIconTheme: const IconThemeData(color: AppColors.primary, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background, elevation: 0,
        scrolledUnderElevation: 0, surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w600,
            color: AppColors.onSurface, letterSpacing: 0.5),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerHigh, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
        clipBehavior: Clip.antiAlias, margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(borderRadius: AppRadius.cardAll, borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadius.cardAll, borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: AppRadius.cardAll,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.nunito(fontSize: 14, color: AppColors.outline),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerHigh, selectedColor: AppColors.primaryContainer,
        labelStyle: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.chipAll, side: BorderSide.none),
        side: BorderSide.none, elevation: 0,
      ),
      dividerTheme: const DividerThemeData(color: Colors.transparent, thickness: 0, space: 0),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHighest,
        contentTextStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        actionTextColor: AppColors.gold, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll), elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerHigh, surfaceTintColor: Colors.transparent, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
        titleTextStyle: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.onSurface, letterSpacing: 0.3),
        contentTextStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerHigh, surfaceTintColor: Colors.transparent,
        elevation: 0, modalElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet))),
        clipBehavior: Clip.antiAlias,
        dragHandleColor: AppColors.surfaceContainerHighest, dragHandleSize: Size(48, 4),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.onPrimary : AppColors.outline),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceContainerHighest),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceContainerHighest),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.outline, width: 1.5),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}

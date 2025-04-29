import "package:flex_color_scheme/flex_color_scheme.dart";
import "package:flutter/cupertino.dart";

abstract final class AppThemes {
  static final light = FlexThemeData.light(
    scheme: _FCSConfigs.scheme,
    surfaceMode: _FCSConfigs.surfaceMode,
    blendLevel: _FCSConfigs.blendLevel.light,
    appBarStyle: _FCSConfigs.appBarStyle,
    bottomAppBarElevation: _FCSConfigs.bottomAppBarElevation,
    subThemesData: _FCSConfigs.subThemesData.light,
    keyColors: _FCSConfigs.keyColors.light,
    tones: _FCSConfigs.tones.light,
    visualDensity: _FCSConfigs.visualDensity,
    cupertinoOverrideTheme: _FCSConfigs.cupertinoOverrideTheme,
  );

  static final dark = FlexThemeData.dark(
    scheme: _FCSConfigs.scheme,
    surfaceMode: _FCSConfigs.surfaceMode,
    blendLevel: _FCSConfigs.blendLevel.dark,
    appBarStyle: _FCSConfigs.appBarStyle,
    bottomAppBarElevation: _FCSConfigs.bottomAppBarElevation,
    subThemesData: _FCSConfigs.subThemesData.dark,
    keyColors: _FCSConfigs.keyColors.dark,
    tones: _FCSConfigs.tones.dark,
    visualDensity: _FCSConfigs.visualDensity,
    cupertinoOverrideTheme: _FCSConfigs.cupertinoOverrideTheme,
  );
}

abstract final class _FCSConfigs {
  static const scheme = FlexScheme.brandBlue;

  // Surface color adjustments
  static const surfaceMode = FlexSurfaceMode.highBackgroundLowScaffold;
  static const blendLevel = (light: 1, dark: 2);

  // Direct styling props
  static const appBarStyle = FlexAppBarStyle.background;
  static const bottomAppBarElevation = 2.0;

  // Component theme configs
  static const subThemesData = (
    light: FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 8,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.primary,
      segmentedButtonSchemeColor: SchemeColor.primary,
      segmentedButtonBorderSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
        12,
        16,
        12,
        12,
      ),
      inputDecoratorBackgroundAlpha: 7,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 8.0,
      inputDecoratorUnfocusedBorderIsColored: true,
      inputDecoratorBorderWidth: 1.0,
      inputDecoratorFocusedBorderWidth: 2.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.onPrimaryFixedVariant,
      inputDecoratorSuffixIconSchemeColor: SchemeColor.primary,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.tertiary,
      popupMenuRadius: 8.0,
      popupMenuElevation: 3.0,
      alignedDropdown: true,
      drawerIndicatorRadius: 12.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 8.0,
      menuElevation: 3.0,
      menuBarRadius: 0.0,
      menuBarElevation: 2.0,
      menuBarShadowColor: Color(0x00000000),
      searchBarElevation: 1.0,
      searchViewElevation: 1.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarIndicatorRadius: 12.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
      navigationRailIndicatorRadius: 12.0,
      navigationRailBackgroundSchemeColor: SchemeColor.surface,
    ),
    dark: FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 10,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 12.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.primary,
      segmentedButtonSchemeColor: SchemeColor.primary,
      segmentedButtonBorderSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
        12,
        16,
        12,
        12,
      ),
      inputDecoratorBackgroundAlpha: 40,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 8.0,
      inputDecoratorUnfocusedBorderIsColored: true,
      inputDecoratorBorderWidth: 1.0,
      inputDecoratorFocusedBorderWidth: 2.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primaryFixed,
      inputDecoratorSuffixIconSchemeColor: SchemeColor.primary,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.tertiary,
      popupMenuRadius: 8.0,
      popupMenuElevation: 3.0,
      alignedDropdown: true,
      drawerIndicatorRadius: 12.0,
      drawerIndicatorSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      menuRadius: 8.0,
      menuElevation: 3.0,
      menuBarRadius: 0.0,
      menuBarElevation: 2.0,
      menuBarShadowColor: Color(0x00000000),
      searchBarElevation: 1.0,
      searchViewElevation: 1.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationBarIndicatorSchemeColor: SchemeColor.primary,
      navigationBarIndicatorRadius: 12.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 1.00,
      navigationRailIndicatorRadius: 12.0,
      navigationRailBackgroundSchemeColor: SchemeColor.surface,
    ),
  );

  // ColorScheme seed generation configurations
  static const keyColors = (
    light: FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      keepPrimary: true,
    ),
    dark: FlexKeyColors(useSecondary: true, useTertiary: true),
  );
  static final tones = (
    light: FlexSchemeVariant.jolly.tones(Brightness.light),
    dark: FlexSchemeVariant.jolly.tones(Brightness.dark),
  );

  // Direct [ThemeData] props
  static final visualDensity = FlexColorScheme.comfortablePlatformDensity;
  static const cupertinoOverrideTheme = CupertinoThemeData(
    applyThemeToAll: true,
  );
}

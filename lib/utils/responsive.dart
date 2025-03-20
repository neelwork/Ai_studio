// lib/utils/responsive.dart
import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1200;

  final BuildContext context;
  final Size _screenSize;

  Responsive(this.context) : _screenSize = MediaQuery.of(context).size;

  // Singleton factory for convenience
  static Responsive of(BuildContext context) => Responsive(context);

  // Screen size getters
  double get width => _screenSize.width;
  double get height => _screenSize.height;

  // Device type checks
  bool get isMobile => width < mobileBreakpoint;
  bool get isTablet => width >= mobileBreakpoint && width < desktopBreakpoint;
  bool get isDesktop => width >= desktopBreakpoint;

  // Responsive value calculations
  double wp(double percent) => width * percent / 100;
  double hp(double percent) => height * percent / 100;

  // Responsive padding
  EdgeInsets get screenPadding => isMobile
      ? const EdgeInsets.all(16)
      : isTablet
      ? const EdgeInsets.all(24)
      : const EdgeInsets.all(32);

  // Responsive dimensions
  double responsiveWidth({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  double responsiveHeight({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Responsive font size
  double responsiveFontSize({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Get responsive value based on screen width
  T getResponsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
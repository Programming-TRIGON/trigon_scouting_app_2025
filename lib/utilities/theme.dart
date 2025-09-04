import 'package:flutter/material.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2a638a),
      surfaceTint: Color(0xff2a638a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcbe6ff),
      onPrimaryContainer: Color(0xff024b71),
      secondary: Color(0xff50606f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd4e4f6),
      onSecondaryContainer: Color(0xff394856),
      tertiary: Color(0xff66587b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffecdcff),
      onTertiaryContainer: Color(0xff4d4162),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff181c20),
      onSurfaceVariant: Color(0xff42474d),
      outline: Color(0xff72787e),
      outlineVariant: Color(0xffc1c7ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff97ccf9),
      primaryFixed: Color(0xffcbe6ff),
      onPrimaryFixed: Color(0xff001e30),
      primaryFixedDim: Color(0xff97ccf9),
      onPrimaryFixedVariant: Color(0xff024b71),
      secondaryFixed: Color(0xffd4e4f6),
      onSecondaryFixed: Color(0xff0d1d29),
      secondaryFixedDim: Color(0xffb8c8d9),
      onSecondaryFixedVariant: Color(0xff394856),
      tertiaryFixed: Color(0xffecdcff),
      onTertiaryFixed: Color(0xff211634),
      tertiaryFixedDim: Color(0xffd0bfe7),
      onTertiaryFixedVariant: Color(0xff4d4162),
      surfaceDim: Color(0xffd7dadf),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f4f9),
      surfaceContainer: Color(0xffebeef3),
      surfaceContainerHigh: Color(0xffe6e8ed),
      surfaceContainerHighest: Color(0xffe0e3e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003a59),
      surfaceTint: Color(0xff2a638a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3b729a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff283845),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5f6f7e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3c3050),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff75678a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff0e1215),
      onSurfaceVariant: Color(0xff31373d),
      outline: Color(0xff4d5359),
      outlineVariant: Color(0xff686e74),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff97ccf9),
      primaryFixed: Color(0xff3b729a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1d5980),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5f6f7e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff475765),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff75678a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5c4f71),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c7cc),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f4f9),
      surfaceContainer: Color(0xffe6e8ed),
      surfaceContainerHigh: Color(0xffdadde2),
      surfaceContainerHighest: Color(0xffcfd2d7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002f49),
      surfaceTint: Color(0xff2a638a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff084d74),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1e2e3b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3b4b59),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff322646),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff504364),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272d32),
      outlineVariant: Color(0xff444a50),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff97ccf9),
      primaryFixed: Color(0xff084d74),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003653),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3b4b59),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff253442),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff504364),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff392d4d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6b9be),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef1f6),
      surfaceContainer: Color(0xffe0e3e8),
      surfaceContainerHigh: Color(0xffd2d4da),
      surfaceContainerHighest: Color(0xffc4c7cc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff97ccf9),
      surfaceTint: Color(0xff97ccf9),
      onPrimary: Color(0xff003450),
      primaryContainer: Color(0xff024b71),
      onPrimaryContainer: Color(0xffcbe6ff),
      secondary: Color(0xffb8c8d9),
      onSecondary: Color(0xff22323f),
      secondaryContainer: Color(0xff394856),
      onSecondaryContainer: Color(0xffd4e4f6),
      tertiary: Color(0xffd0bfe7),
      onTertiary: Color(0xff372b4a),
      tertiaryContainer: Color(0xff4d4162),
      onTertiaryContainer: Color(0xffecdcff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101417),
      onSurface: Color(0xffe0e3e8),
      onSurfaceVariant: Color(0xffc1c7ce),
      outline: Color(0xff8c9198),
      outlineVariant: Color(0xff42474d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e8),
      inversePrimary: Color(0xff2a638a),
      primaryFixed: Color(0xffcbe6ff),
      onPrimaryFixed: Color(0xff001e30),
      primaryFixedDim: Color(0xff97ccf9),
      onPrimaryFixedVariant: Color(0xff024b71),
      secondaryFixed: Color(0xffd4e4f6),
      onSecondaryFixed: Color(0xff0d1d29),
      secondaryFixedDim: Color(0xffb8c8d9),
      onSecondaryFixedVariant: Color(0xff394856),
      tertiaryFixed: Color(0xffecdcff),
      onTertiaryFixed: Color(0xff211634),
      tertiaryFixedDim: Color(0xffd0bfe7),
      onTertiaryFixedVariant: Color(0xff4d4162),
      surfaceDim: Color(0xff101417),
      surfaceBright: Color(0xff363a3e),
      surfaceContainerLowest: Color(0xff0b0f12),
      surfaceContainerLow: Color(0xff181c20),
      surfaceContainer: Color(0xff1c2024),
      surfaceContainerHigh: Color(0xff262a2e),
      surfaceContainerHighest: Color(0xff313539),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbfe0ff),
      surfaceTint: Color(0xff97ccf9),
      onPrimary: Color(0xff002840),
      primaryContainer: Color(0xff6196c0),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcedef0),
      onSecondary: Color(0xff172734),
      secondaryContainer: Color(0xff8293a2),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe7d5fe),
      onTertiary: Color(0xff2b203f),
      tertiaryContainer: Color(0xff998ab0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd7dde4),
      outline: Color(0xffadb2ba),
      outlineVariant: Color(0xff8b9198),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e8),
      inversePrimary: Color(0xff054c72),
      primaryFixed: Color(0xffcbe6ff),
      onPrimaryFixed: Color(0xff001321),
      primaryFixedDim: Color(0xff97ccf9),
      onPrimaryFixedVariant: Color(0xff003a59),
      secondaryFixed: Color(0xffd4e4f6),
      onSecondaryFixed: Color(0xff03131f),
      secondaryFixedDim: Color(0xffb8c8d9),
      onSecondaryFixedVariant: Color(0xff283845),
      tertiaryFixed: Color(0xffecdcff),
      onTertiaryFixed: Color(0xff160b29),
      tertiaryFixedDim: Color(0xffd0bfe7),
      onTertiaryFixedVariant: Color(0xff3c3050),
      surfaceDim: Color(0xff101417),
      surfaceBright: Color(0xff414549),
      surfaceContainerLowest: Color(0xff05080b),
      surfaceContainerLow: Color(0xff1a1e22),
      surfaceContainer: Color(0xff24282c),
      surfaceContainerHigh: Color(0xff2f3337),
      surfaceContainerHighest: Color(0xff3a3e42),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe5f1ff),
      surfaceTint: Color(0xff97ccf9),
      onPrimary: Color(0xff000000),
      primaryContainer: Colors.grey,
      onPrimaryContainer: Color(0xff000c18),
      secondary: Color(0xffe5f1ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb4c5d5),
      onSecondaryContainer: Color(0xff000c18),
      tertiary: Color(0xfff7ecff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffccbce3),
      onTertiaryContainer: Color(0xff100523),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf0f8),
      outlineVariant: Color(0xffbec3ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e8),
      inversePrimary: Color(0xff054c72),
      primaryFixed: Color(0xffcbe6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff97ccf9),
      onPrimaryFixedVariant: Color(0xff001321),
      secondaryFixed: Color(0xffd4e4f6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb8c8d9),
      onSecondaryFixedVariant: Color(0xff03131f),
      tertiaryFixed: Color(0xffecdcff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd0bfe7),
      onTertiaryFixedVariant: Color(0xff160b29),
      surfaceDim: Color(0xff101417),
      surfaceBright: Color(0xff4d5055),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c2024),
      surfaceContainer: Color(0xff2d3135),
      surfaceContainerHigh: Color(0xff383c40),
      surfaceContainerHighest: Color(0xff43474b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

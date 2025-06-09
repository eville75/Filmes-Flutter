import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const String logoSvg = '''
    <svg xmlns="http://www.w3.org/2000/svg" width="150" height="40" viewBox="0 0 150 40">
      <text x="0" y="30" font-family="Arial, sans-serif" font-size="30" font-weight="bold" fill="{color}">
        CINE
        <tspan font-weight="normal">APP</tspan>
      </text>
    </svg>
    ''';
    // Substitui a cor no SVG pela cor primária do tema atual
    final String coloredLogo = logoSvg.replaceFirst('{color}', '#${theme.primaryColor.value.toRadixString(16).substring(2)}');

    return SvgPicture.string(
      coloredLogo,
      height: size,
    );
  }
}

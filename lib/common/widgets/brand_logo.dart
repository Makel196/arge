import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/decor/pgr_logo.svg',
      height: height ?? 64,
      fit: BoxFit.contain,
      semanticsLabel: 'PGR Drive Technologies',
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 280,
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primary, Color(0xFF117B75)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.sticky_note_2_outlined, color: Colors.white, size: 40),
        SizedBox(height: 6),
        Text(
          'NewsBay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'LexendDeca',
          ),
        ),
        SizedBox(height: 32),
      ],
    ),
  );
}

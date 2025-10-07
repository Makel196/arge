import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pgr_arge_sistemleri/features/home/presentation/home_screen.dart';

import '../theme/app_theme.dart';
import '../theme/neomorphism.dart';
import 'brand_logo.dart';

class ComingSoonScaffold extends StatelessWidget {
  const ComingSoonScaffold({
    super.key,
    required this.title,
    this.message = 'Yakinda icerikler yuklenecek.',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = AppTextStyles.titleLarge(context).copyWith(
      fontWeight: FontWeight.w700,
      color: Colors.black,
      letterSpacing: 0.4,
      fontSize: 24,
    );
    final TextStyle bodyStyle = AppTextStyles.bodyLarge(context).copyWith(
      color: AppColors.muted,
      height: 1.5,
    );

    void handleBack() {
      final GoRouter router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
      } else {
        router.go(HomeScreen.routePath);
      }
    }

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    onPressed: handleBack,
                    child: const Icon(CupertinoIcons.back, color: Colors.black),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BrandLogo(height: 48),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s32),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      Text(
                        message,
                        style: bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

/// The profile tab content, kept independent from the dashboard shell.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.user,
    required this.onBack,
    required this.onUnavailable,
  });

  final AppUser user;
  final VoidCallback onBack;
  final VoidCallback onUnavailable;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.chevron_left, size: 35),
                  tooltip: 'Back to home',
                ),
              ),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                  fontFamily: 'LexendDeca',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                const SizedBox(height: 7),
                _ProfileAvatar(user: user),
                const SizedBox(height: 9),
                Text(
                  user.displayName.isEmpty ? user.username : user.displayName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'LexendDeca',
                  ),
                ),
                const SizedBox(height: 27),
                _ProfileMenuItem(
                  svgAsset: 'assets/svg/settings.svg',
                  label: 'Settings',
                  onTap: onUnavailable,
                ),
                _ProfileMenuItem(
                  svgAsset: 'assets/svg/persons.svg',
                  label: 'My Friends',
                  onTap: onUnavailable,
                ),
                _ProfileMenuItem(
                  svgAsset: 'assets/svg/heart.svg',
                  label: 'My Favourite',
                  onTap: onUnavailable,
                ),
                _ProfileMenuItem(
                  svgAsset: 'assets/svg/star.svg',
                  label: 'Latest Reviews',
                  onTap: onUnavailable,
                ),
                _ProfileMenuItem(
                  svgAsset: 'assets/svg/wifi.svg',
                  label: 'Followers',
                  onTap: onUnavailable,
                ),
                const Spacer(),
                _ProfileMenuItem(
                  svgAsset: 'assets/svg/poweroff.svg',
                  label: 'Log Out',
                  color: AppColors.critical,
                  onTap: () =>
                      context.read<AuthBloc>().add(const LogoutRequested()),
                ),
                const SizedBox(height: 23),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.primary,
        foregroundImage: user.image == null || user.image!.isEmpty
            ? null
            : NetworkImage(user.image!),
        child: Text(
          user.initials.isEmpty ? 'U' : user.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'LexendDeca',
          ),
        ),
      ),
      Positioned(
        right: -1,
        bottom: -1,
        child: Container(
          width: 17,
          height: 17,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.camera_alt, size: 10, color: Colors.white),
        ),
      ),
    ],
  );
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.svgAsset,
    this.color = AppColors.onSurface,
  }) : assert(icon != null || svgAsset != null);

  final IconData? icon;
  final String? svgAsset;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            SizedBox(
              width: 33,
              child: svgAsset == null
                  ? Icon(icon, size: 20, color: color)
                  : SvgPicture.asset(
                      svgAsset!,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'LexendDeca',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

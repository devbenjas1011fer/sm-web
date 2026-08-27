import 'package:flutter/material.dart';
import 'package:sm_web/infra/storage/session.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SessionStorage.session;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final String name = user.nombre ?? 'Usuario';

    return PopupMenuButton<int>(
      tooltip: 'Cuenta',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 12),
      elevation: 12,
      color: Colors.white,
      padding: EdgeInsets.zero,

      constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      // ============================================================
      // BOTÓN PRINCIPAL
      // ============================================================
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(width: 6),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),

      onSelected: (value) {
        if (value == 1) {
          // HomeService.to.logout();
        }
      },

      itemBuilder: (context) => [
        PopupMenuItem<int>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cuenta',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: .5,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Administrador',
                  style: TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // const PopupMenuDivider(),
        // const PopupMenuItem<int>(
        //   enabled: false,
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 16,
        //     vertical: 4,
        //   ),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.person_outline_rounded,
        //         size: 20,
        //         color: Color(0xFF4B5563),
        //       ),

        //       SizedBox(width: 12),

        //       Expanded(
        //         child: Text(
        //           'Mi perfil',
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w500,
        //             color: Color(0xFF1F2937),
        //           ),
        //         ),
        //       ),

        //       Icon(
        //         Icons.chevron_right_rounded,
        //         size: 19,
        //         color: Color(0xFF9CA3AF),
        //       ),
        //     ],
        //   ),
        // ),
        // const PopupMenuItem<int>(
        //   enabled: false,
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 16,
        //     vertical: 4,
        //   ),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.settings_outlined,
        //         size: 20,
        //         color: Color(0xFF4B5563),
        //       ),

        //       SizedBox(width: 12),

        //       Expanded(
        //         child: Text(
        //           'Configuración',
        //           style: TextStyle(
        //             fontSize: 14,
        //             fontWeight: FontWeight.w500,
        //             color: Color(0xFF1F2937),
        //           ),
        //         ),
        //       ),

        //       Icon(
        //         Icons.chevron_right_rounded,
        //         size: 19,
        //         color: Color(0xFF9CA3AF),
        //       ),
        //     ],
        //   ),
        // ),
        const PopupMenuDivider(),

        const PopupMenuItem<int>(
          value: 1,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 20, color: Color(0xFFDC2626)),

              SizedBox(width: 12),

              Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

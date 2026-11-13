import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/ui_helpers.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../state/alerts_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/panels_provider.dart';

/// User profile with edit + quick stats.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _edit(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final nameCtrl = TextEditingController(text: auth.user?.name ?? '');
    final phoneCtrl = TextEditingController(text: auth.user?.phone ?? '');

    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await auth.updateProfile(name: nameCtrl.text, phone: phoneCtrl.text);
    if (!context.mounted) return;
    AppSnackBar.success('Profile updated.');
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final auth = context.watch<AuthProvider>();
    final panels = context.watch<PanelsProvider>();
    final alerts = context.watch<AlertsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFFF7A021),
                  child: Text(
                    (auth.user?.name.isNotEmpty ?? false)
                        ? auth.user!.name[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  auth.user?.name ?? 'Solar Owner',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                Text(
                  auth.user?.email ?? '—',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Member since '
                  '${auth.user == null ? "—" : AppFormatters.date(auth.user!.createdAt)}',
                  style: TextStyle(fontSize: 11, color: p.textFaint),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _edit(context),
                  icon: const Icon(Icons.edit, size: 17),
                  label: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _StatCard(
                icon: Icons.solar_power,
                color: const Color(0xFFF7A021),
                value: '${panels.total}',
                label: 'Plates',
              ),
              const SizedBox(width: 10),
              _StatCard(
                icon: Icons.bolt,
                color: const Color(0xFF2E9E5B),
                value: AppFormatters.kwh(panels.todayKwh),
                label: 'Today',
              ),
              const SizedBox(width: 10),
              _StatCard(
                icon: Icons.check_circle,
                color: const Color(0xFF2E7DD1),
                value: '${alerts.resolvedAlerts.length}',
                label: 'Resolved',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: p.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.cardBorder),
            ),
            child: Text(
              'Yeh app aapke solar plates ko 24/7 monitor karti hai. '
              'Har plate ka IoT device live readings bhejta hai, aur koi bhi '
              'plate kharab hoti hai to alarm bajta hai — taake baqi plates '
              'bhi mehfooz rahen.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: p.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 7),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: p.textPrimary,
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10.5, color: p.textFaint),
            ),
          ],
        ),
      ),
    );
  }
}

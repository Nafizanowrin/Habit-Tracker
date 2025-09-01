import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../common/providers/theme_provider.dart';
import '../../../common/providers/notification_provider.dart';
import '../../profile/presentation/edit_profile_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      // Simulate saving settings
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    try {
      final authController = ref.read(authControllerProvider);
      await authController.signOut();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign out failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final notificationSettings = ref.watch(notificationProvider);
    final notificationNotifier = ref.read(notificationProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveSettings,
            child: _isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildSection(
            title: 'Profile',
            icon: Icons.person_rounded,
            color: theme.colorScheme.primary,
            children: [
              _buildListTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Preferences Section
          _buildSection(
            title: 'Preferences',
            icon: Icons.settings_rounded,
            color: theme.colorScheme.secondary,
            children: [
              _buildThemeSelector(
                icon: Icons.palette_rounded,
                title: 'Theme',
                subtitle: _getThemeDescription(themeMode),
                currentTheme: themeMode,
                onThemeChanged: (newTheme) {
                  themeNotifier.setTheme(newTheme);
                },
              ),
              _buildSwitchTile(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                subtitle: 'Receive habit reminders',
                value: notificationSettings.notificationsEnabled,
                onChanged: (value) {
                  notificationNotifier.updateNotificationsEnabled(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Support Section
          _buildSection(
            title: 'Support',
            icon: Icons.help_rounded,
            color: Colors.orange,
            children: [
              _buildListTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & FAQ',
                subtitle: 'Get help and answers',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & FAQ coming soon!'),
                    ),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.feedback_rounded,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feedback feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // About Section
          _buildSection(
            title: 'About',
            icon: Icons.info_rounded,
            color: Colors.blue,
            children: [
              _buildListTile(
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms of Service coming soon!'),
                    ),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                subtitle: 'Learn about our privacy practices',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy Policy coming soon!'),
                    ),
                  );
                },
              ),
              _buildListTile(
                icon: Icons.info_outline_rounded,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sign Out Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeDescription(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light theme';
      case ThemeMode.dark:
        return 'Dark theme';
      case ThemeMode.system:
        return 'System default';
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeSelector({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeMode currentTheme,
    required ValueChanged<ThemeMode> onThemeChanged,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7)),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: PopupMenuButton<ThemeMode>(
        icon: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.5)),
        onSelected: onThemeChanged,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: ThemeMode.light,
            child: Row(
              children: [
                Icon(
                  Icons.light_mode_rounded,
                  color: currentTheme == ThemeMode.light ? theme.colorScheme.primary : null,
                ),
                const SizedBox(width: 8),
                Text('Light'),
                if (currentTheme == ThemeMode.light) ...[
                  const Spacer(),
                  Icon(Icons.check_rounded, color: theme.colorScheme.primary),
                ],
              ],
            ),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Row(
              children: [
                Icon(
                  Icons.dark_mode_rounded,
                  color: currentTheme == ThemeMode.dark ? theme.colorScheme.primary : null,
                ),
                const SizedBox(width: 8),
                Text('Dark'),
                if (currentTheme == ThemeMode.dark) ...[
                  const Spacer(),
                  Icon(Icons.check_rounded, color: theme.colorScheme.primary),
                ],
              ],
            ),
          ),
          PopupMenuItem(
            value: ThemeMode.system,
            child: Row(
              children: [
                Icon(
                  Icons.settings_system_daydream_rounded,
                  color: currentTheme == ThemeMode.system ? theme.colorScheme.primary : null,
                ),
                const SizedBox(width: 8),
                Text('System'),
                if (currentTheme == ThemeMode.system) ...[
                  const Spacer(),
                  Icon(Icons.check_rounded, color: theme.colorScheme.primary),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7)),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: onTap != null
          ? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.5))
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7)),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

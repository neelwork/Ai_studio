import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../utils/colors.dart';
import '../../utils/responsive.dart';
import '../../widget/app_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final nameController = TextEditingController(text: "Motionize Studio");
  final emailController = TextEditingController(text: "motionizestudio@gmail.com");
  final passwordController = TextEditingController(text: "•••••••");
  final confirmPasswordController = TextEditingController(text: "•••••••");
  String themeMode = "System";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.lightTheme
          : AppColors.darkTheme,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: responsive.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Main settings card
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Email fields
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Name :'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email :'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Password fields
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Password:'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Confirm Password:'),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Save button
                      Center(
                        child: SizedBox(
                          width: 120,
                          child: AppButton(
                            text: 'Save',
                            onPressed: () {
                              // Save user settings
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Settings saved successfully')),
                              );
                            },
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            borderRadius: 4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      // Theme and Delete options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Theme selector
                          Row(
                            children: [
                              const Text('Theme Mode : '),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton<String>(
                                  value: themeMode,
                                  underline: const SizedBox(),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        themeMode = newValue;
                                      });

                                      // Update app theme
                                      final themeProvider = ThemeProvider.of(context);
                                      if (newValue == 'System') {
                                        themeProvider.setThemeMode(ThemeMode.system);
                                      } else if (newValue == 'Light') {
                                        themeProvider.setThemeMode(ThemeMode.light);
                                      } else if (newValue == 'Dark') {
                                        themeProvider.setThemeMode(ThemeMode.dark);
                                      }
                                    }
                                  },
                                  items: <String>['System', 'Light', 'Dark']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),

                          // Delete chats
                          Row(
                            children: [
                              const Text('Delete All Chats : '),
                              const SizedBox(width: 8),
                              AppButton(
                                text: 'Delete All Chats',
                                onPressed: () {
                                  // Show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete All Chats'),
                                      content: const Text('Are you sure you want to delete all chats? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Delete chats logic
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('All chats have been deleted')),
                                            );
                                          },
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                borderRadius: 4,
                                height: 36,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // About section
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // About buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildAboutButton(
                        icon: Icons.help_outline,
                        text: 'Help Center',
                        onTap: () {
                          // Navigate to help center
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAboutButton(
                        icon: Icons.article_outlined,
                        text: 'Terms of Use',
                        onTap: () {
                          // Navigate to terms of use
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAboutButton(
                        icon: Icons.privacy_tip_outlined,
                        text: 'Privacy Policy',
                        onTap: () {
                          // Navigate to privacy policy
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Version info
                Center(
                  child: Text(
                    'AINAME Version : 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

// Theme Provider for managing app theme
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Method to get the provider instance from context
  static ThemeProvider of(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false);
  }
}

// App theme data
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: AppColors.lightTheme,
    cardColor: AppColors.lightTheme,
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.black.withOpacity(.83)
      ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: AppColors.darkTheme,
    cardColor: AppColors.darkTheme,
    buttonTheme: ButtonThemeData(
        buttonColor: AppColors.white.withOpacity(.83)
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  );
}

// Main app with theme support

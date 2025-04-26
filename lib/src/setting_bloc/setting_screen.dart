import 'package:ai_studio/src/setting_bloc/profile_bloc.dart';
import 'package:ai_studio/src/setting_bloc/update_user_bloc.dart';
import 'package:ai_studio/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/colors.dart';
import '../../widget/app_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController(text: "•••••••");
  final confirmPasswordController = TextEditingController(text: "•••••••");
  String themeMode = "System";

  @override
  void initState() {
    context.read<ProfileBloc>().add(ProfileRequested());
    super.initState();
  }

  bool isPasswordShow = true;
  bool isConfirumPasswordShow = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  double horizontalPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width <= 400) return 8;
    if (width <= 600) return 12;
    return 120;
  }

  double verticalPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= 400 ? 40 : 12;
  }

  bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmall = isSmallScreen(context);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.lightTheme
          : AppColors.darkTheme,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding(context),
              vertical: verticalPadding(context),
            ),
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
                      style: AppTextStyles.regular28.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileSuccess) {
                        nameController.text =
                            state.response.user!.userName.toString();
                        emailController.text =
                            state.response.user!.email.toString();
                        passwordController.text =
                            state.response.user!.password.toString();
                        confirmPasswordController.text =
                            state.response.user!.password.toString();
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppColors.darkTheme
                                    : AppColors.lightTheme,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(isSmall ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and Email fields - Responsive layout
                            isSmall
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name field
                                      Text(
                                        'Name :',
                                        style: AppTextStyles.regular18.copyWith(
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Email field
                                      Text(
                                        'Email :',
                                        style: AppTextStyles.regular18.copyWith(
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name :',
                                              style: AppTextStyles.regular18
                                                  .copyWith(
                                                color: theme
                                                    .textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email :',
                                              style: AppTextStyles.regular18
                                                  .copyWith(
                                                color: theme
                                                    .textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                            const SizedBox(height: 16),

                            // Password fields - Responsive layout
                            isSmall
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Password field
                                      Text(
                                        'Password:',
                                        style: AppTextStyles.regular18.copyWith(
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: passwordController,
                                        obscureText: isPasswordShow,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(isPasswordShow
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                isPasswordShow =
                                                    !isPasswordShow;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Confirm Password field
                                      Text(
                                        'Confirm Password:',
                                        style: AppTextStyles.regular18.copyWith(
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: confirmPasswordController,
                                        obscureText: isConfirumPasswordShow,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(isConfirumPasswordShow
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                isConfirumPasswordShow =
                                                    !isConfirumPasswordShow;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 12),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Password:',
                                              style: AppTextStyles.regular18
                                                  .copyWith(
                                                color: theme
                                                    .textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: passwordController,
                                              obscureText: isPasswordShow,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(isPasswordShow
                                                      ? Icons.visibility_off
                                                      : Icons.visibility),
                                                  onPressed: () {
                                                    setState(() {
                                                      isPasswordShow =
                                                          !isPasswordShow;
                                                    });
                                                  },
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Confirm Password:',
                                              style: AppTextStyles.regular18
                                                  .copyWith(
                                                color: theme
                                                    .textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller:
                                                  confirmPasswordController,
                                              obscureText:
                                                  isConfirumPasswordShow,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      isConfirumPasswordShow
                                                          ? Icons.visibility_off
                                                          : Icons.visibility),
                                                  onPressed: () {
                                                    setState(() {
                                                      isConfirumPasswordShow =
                                                          !isConfirumPasswordShow;
                                                    });
                                                  },
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
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
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 100),
                                // width: 120,
                                child: BlocConsumer<UpdateUserBloc,
                                    UpdateUserState>(
                                  listener: (context, state) {
                                    if (state is UpdateUserSuccess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Settings saved successfully',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return AppButton(
                                      text: state is UpdateUserLoading
                                          ? 'Loading...'
                                          : 'Save',
                                      onPressed: () {
                                        context.read<UpdateUserBloc>().add(
                                              UpdateUserRequested(
                                                emailController.text,
                                                passwordController.text,
                                                nameController.text,
                                              ),
                                            );
                                      },
                                      backgroundColor: Theme.of(context)
                                                  .brightness ==
                                              Brightness.light
                                          ? AppColors.black.withOpacity(.79)
                                          : AppColors.white.withOpacity(.79),
                                      textColor: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? AppColors.white
                                          : AppColors.black,
                                      borderRadius: 4,
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),

                            // Theme and Delete options - Responsive layout
                            isSmall
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Theme selector
                                      Row(
                                        children: [
                                          Text(
                                            'Theme Mode : ',
                                            style:
                                                AppTextStyles.medium20.copyWith(
                                              color: theme
                                                  .textTheme.bodyLarge?.color,
                                              fontSize: isSmall ? 16 : 20,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: DropdownButton<String>(
                                              value: themeMode,
                                              underline: const SizedBox(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  setState(() {
                                                    themeMode = newValue;
                                                  });

                                                  // Update app theme
                                                  final themeProvider =
                                                      ThemeProvider.of(context);
                                                  if (newValue == 'System') {
                                                    themeProvider.setThemeMode(
                                                        ThemeMode.system);
                                                  } else if (newValue ==
                                                      'Light') {
                                                    themeProvider.setThemeMode(
                                                        ThemeMode.light);
                                                  } else if (newValue ==
                                                      'Dark') {
                                                    themeProvider.setThemeMode(
                                                        ThemeMode.dark);
                                                  }
                                                }
                                              },
                                              items: <String>[
                                                'System',
                                                'Light',
                                                'Dark'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      // Delete chats
                                      Text(
                                        'Delete All Chats : ',
                                        style: AppTextStyles.medium20.copyWith(
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                          fontSize: isSmall ? 16 : 20,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: AppButton(
                                          text: 'Delete All Chats',
                                          onPressed: () {
                                            // Show confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Delete All Chats'),
                                                content: const Text(
                                                    'Are you sure you want to delete all chats? This action cannot be undone.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      // Delete chats logic
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'All chats have been deleted')),
                                                      );
                                                    },
                                                    child: const Text('Delete',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          borderRadius: 4,
                                          height: 50,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Theme selector
                                      Row(
                                        children: [
                                          Text(
                                            'Theme Mode : ',
                                            style:
                                                AppTextStyles.medium20.copyWith(
                                              color: theme
                                                  .textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: DropdownButton<String>(
                                              value: themeMode,
                                              underline: const SizedBox(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  setState(() {
                                                    themeMode = newValue;
                                                  });

                                                  // Update app theme
                                                  final themeProvider =
                                                      ThemeProvider.of(context);
                                                  if (newValue == 'System') {
                                                    themeProvider.setThemeMode(
                                                        ThemeMode.system);
                                                  } else if (newValue ==
                                                      'Light') {
                                                    themeProvider.setThemeMode(
                                                        ThemeMode.light);
                                                  } else if (newValue ==
                                                      'Dark') {
                                                    themeProvider.setThemeMode(
                                                        ThemeMode.dark);
                                                  }
                                                }
                                              },
                                              items: <String>[
                                                'System',
                                                'Light',
                                                'Dark'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
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
                                          Text(
                                            'Delete All Chats : ',
                                            style:
                                                AppTextStyles.medium20.copyWith(
                                              color: theme
                                                  .textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          AppButton(
                                            text: 'Delete All Chats',
                                            width: 264,
                                            onPressed: () {
                                              // Show confirmation dialog
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      'Delete All Chats'),
                                                  content: const Text(
                                                      'Are you sure you want to delete all chats? This action cannot be undone.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        // Delete chats logic
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'All chats have been deleted')),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            borderRadius: 4,
                                            height: 57,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ProfileSuccess) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppColors.darkTheme
                                    : AppColors.lightTheme,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(isSmall ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Referral Link: ',
                              style: AppTextStyles.regular16.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.darkTheme
                                      : AppColors.lightTheme,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                state.response.user!.referralLink.toString(),
                                style: AppTextStyles.regular16.copyWith(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  final params = ShareParams(
                                    uri: Uri.parse(
                                      state.response.user!.referralLink
                                          .toString(),
                                    ),
                                  );

                                  SharePlus.instance.share(params);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? AppColors.darkTheme
                                          : AppColors.lightTheme,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Share',
                                    style: AppTextStyles.regular16.copyWith(
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center();
                    }
                  },
                ),

                const SizedBox(height: 24),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // About buttons - Responsive layout
                isSmall
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            _buildAboutButton(
                              icon: Icons.help_outline,
                              text: 'Help Center',
                              onTap: () {
                                // Navigate to help center
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildAboutButton(
                              icon: Icons.article_outlined,
                              text: 'Terms of Use',
                              onTap: () {
                                // Navigate to terms of use
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildAboutButton(
                              icon: Icons.privacy_tip_outlined,
                              text: 'Privacy Policy',
                              onTap: () {
                                // Navigate to privacy policy
                              },
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
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
                      ),

                const SizedBox(height: 40),

                // Version info
                const Center(
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
    buttonTheme: ButtonThemeData(buttonColor: AppColors.black.withOpacity(.83)),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: AppColors.darkTheme,
    cardColor: AppColors.darkTheme,
    buttonTheme: ButtonThemeData(buttonColor: AppColors.white.withOpacity(.83)),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
    ),
  );
}

// Main app with theme support

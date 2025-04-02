  import 'package:ai_studio/global_functions_variable.dart';
  import 'package:ai_studio/utils/colors.dart';
  import 'package:ai_studio/utils/text_styles.dart';
  import 'package:ai_studio/widget/app_button.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import '../../model/chat_model.dart';
  import '../../utils/responsive.dart';
  import 'chat_bloc.dart';
  import 'chat_event.dart';
  import 'chat_state.dart';
  
  class ChatScreen extends StatefulWidget {
    const ChatScreen({Key? key}) : super(key: key);
  
    @override
    State<ChatScreen> createState() => _ChatScreenState();
  }
  
  class _ChatScreenState extends State<ChatScreen> {
    final TextEditingController _messageController = TextEditingController();
    bool _isHoveringLogo = false;
    bool _keepSidebarOpen = false;
    bool _isDropdownOpen = false;
    bool _isFileOptionsVisible = false;
  
    @override
    Widget build(BuildContext context) {
      final responsive = Responsive.of(context);
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return BlocProvider(
        create: (context) => ChatBloc(),
        child: Builder(
          builder: (context) {
            return BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    // Add drawer for mobile view
                    drawer: responsive.isMobile
                        ? Drawer(child: _buildSidebar(context, responsive, state))
                        : null,
                    body: SafeArea(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Row(
                                children: [
                                  // Sidebar for tablet and desktop
                                  if (!responsive.isMobile)
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: (state.isSidebarVisible ||
                                              state.isFirstMessageSent)
                                          ? responsive.responsiveWidth(
                                              mobile: 0,
                                              tablet: 250,
                                              desktop: 300,
                                            )
                                          : 0,
                                      child: (state.isSidebarVisible ||
                                              state.isFirstMessageSent)
                                          ? _buildSidebar(
                                              context, responsive, state)
                                          : null,
                                    ),
  
                                  // Main Chat Area
                                  Expanded(
                                    child: Container(
                                      color: !isDarkMode
                                          ? AppColors.lightTheme
                                          : AppColors.darkTheme,
                                      child: Column(
                                        children: [
                                          // Chat header
                                          _buildChatHeader(
                                              context, responsive, state),
  
                                          // Chat messages area - uses Expanded to take available space
                                          Expanded(
                                            child: state.messages.length <= 1 &&
                                                    !state.isFirstMessageSent
                                                ? _buildWelcomeMessage()
                                                : _buildChatMessages(context,
                                                    state.messages, responsive),
                                          ),
  
                                          // Quick action buttons
                                          if (state.messages.length == 1 &&
                                              !state.isFirstMessageSent)
                                            _buildQuickActionButtons(
                                                context, responsive),
  
                                          // Message input - always at bottom
                                          _buildMessageInput(context, responsive),
                                          const SizedBox(
                                            height: 12,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_isFileOptionsVisible)
                                !responsive.isMobile
                                    ? Positioned(
                                        bottom: 80,
                                        // Adjust based on your message input height
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child:
                                              _buildFileOptionsOverlay(responsive),
                                        ),
                                      )
                                    : Positioned(
                                        bottom: 80,
                                        // Adjust based on your message input height
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: _buildFileMobileOptionsRow(),
                                        )),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  
    Widget _buildFileMobileOptionsRow() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFileMobileOptionItem(
              icon: Icons.camera_alt_outlined,
              label: "Camera",
              onTap: () {
                // Implement camera logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
            _buildFileMobileOptionItem(
              icon: Icons.folder_outlined,
              label: "Files",
              onTap: () {
                // Implement file selection logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
            _buildFileMobileOptionItem(
              icon: Icons.image_outlined,
              label: "Images",
              onTap: () {
                // Implement image selection logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
          ],
        ),
      );
    }
  
    // Helper method to create file option items
    Widget _buildFileMobileOptionItem(
        {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 8),
              Text(label,
                  style: AppTextStyles.regular14.copyWith(color: Colors.black87)),
            ],
          ),
        ),
      );
    }
  
    Widget _buildFileOptionsOverlay(Responsive responsive) {
      return Container(
        width: 813,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFileOptionItem(
              icon: "assets/images/chat_files_option.png",
              // You'll need to add this icon
  
              onTap: () {
                // Implement file selection logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
            _buildFileOptionItem(
              icon: "assets/images/images_option.png",
              // You'll need to add this icon
  
              onTap: () {
                // Implement image selection logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
            _buildFileOptionItem(
              icon: "assets/images/camera_option.png",
              // You'll need to add this icon
  
              onTap: () {
                // Implement camera logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
            _buildFileOptionItem(
              icon: "assets/images/voice_option.png",
              // You'll need to add this icon
  
              onTap: () {
                // Implement voice recording logic
                setState(() {
                  _isFileOptionsVisible = false;
                });
              },
            ),
          ],
        ),
      );
    }
  
    Widget _buildFileOptionItem(
        {required String icon, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(
              icon,
              // width: 40,
              // height: 40,
            ),
          ],
        ),
      );
    }
  
    // Welcome message displayed in center when no messages sent
    Widget _buildWelcomeMessage() {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/ai_icon.svg",
                  height: 36,
                  width: 36,
                  colorFilter: ColorFilter.mode(
                      !isDarkMode ? AppColors.black : AppColors.white,
                      BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text("Hi Jay!",
                    style: AppTextStyles.regular24.copyWith(
                      fontWeight: FontWeight.w100,
                      color: !isDarkMode ? AppColors.black : AppColors.white,
                    )),
                const SizedBox(
                  width: 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("How can I help you?",
                style: AppTextStyles.medium28.copyWith(
                  color: !isDarkMode ? AppColors.black : AppColors.white,
                )),
          ],
        ),
      );
    }
  
    Widget _buildAccountDropdown() {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(
          maxWidth: 250, // Add a max width constraint
        ),
        decoration: BoxDecoration(
          color: !isDarkMode ? Colors.white : AppColors.darkTheme,
          border: Border.all(
            color: !isDarkMode ? AppColors.black : AppColors.white,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: _isDropdownOpen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdownItem(
                    "Download App",
                    () {},
                  ),
                  Divider(
                      height: 1,
                      color: !isDarkMode
                          ? AppColors.black.withOpacity(.31)
                          : AppColors.white.withOpacity(.31)),
                  GestureDetector(
                      child: _buildDropdownItem(
                    "Settings",
                    () {
                      print("Button tapped");
  
                      try {
                        nextPage(context, '/settings');
                      } catch (e) {
                        print('Navigation error: $e');
                        // Optionally show a snackbar or dialog
                      }
                    },
                  )),
                  Divider(
                      height: 1,
                      color: !isDarkMode
                          ? AppColors.black.withOpacity(.31)
                          : AppColors.white.withOpacity(.31)),
                  _buildDropdownItem(
                    "Log Out",
                    () {
                      nextPage(context, '/auth');
                    },
                  ),
                ],
              )
            : null,
      );
    }
  
    Widget _buildDropdownItem(String title, VoidCallback onTap) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return InkWell(
        onTap: () {
          setState(() {
            _isDropdownOpen = false;
          });
          onTap();
        },
        child: Container(
          // constraints: BoxConstraints(maxWidth: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: double.infinity,
          child: Text(
            title,
            style: AppTextStyles.regular16
                .copyWith(color: !isDarkMode ? AppColors.black : AppColors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  
    Widget _buildSidebar(
        BuildContext context, Responsive responsive, ChatState state) {
      final sidebarPadding = responsive.getResponsiveValue(
        mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        tablet: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return Container(
        color: !isDarkMode ? AppColors.white : AppColors.black.withOpacity(.4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Fixed elements at the top
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI name header
                  Container(
                    padding: sidebarPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AI NAME',
                          style: responsive
                              .getResponsiveValue(
                                mobile: AppTextStyles.medium18,
                                tablet: AppTextStyles.medium20,
                                desktop: AppTextStyles.regular24,
                              )
                              .copyWith(
                                color: !isDarkMode
                                    ? AppColors.black
                                    : AppColors.white,
                              ),
                        ),
                        IconButton(
                            onPressed: () {
                              print("Closing Sidebar...");
                              setState(() {
                                _isHoveringLogo = false;
                              });
  
                              // Don't close immediately, add a small delay
                              if (!state.isFirstMessageSent &&
                                  !_keepSidebarOpen) {
                                print("isSideBar Open");
                                Future.delayed(const Duration(milliseconds: 100),
                                    () {
                                  if (!_isHoveringLogo && !_keepSidebarOpen) {
                                    print("isHovering");
                                    context
                                        .read<ChatBloc>()
                                        .add(ToggleSidebarEvent(false));
                                  }
                                });
                              }
                            },
                            icon: SvgPicture.asset("assets/icons/expand_icon.svg",
                                colorFilter: ColorFilter.mode(
                                    !isDarkMode
                                        ? AppColors.black
                                        : AppColors.white,
                                    BlendMode.srcIn)))
                      ],
                    ),
                  ),
  
                  // New chat button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 8.0),
                    child: AppButton.outlined(
                      onPressed: responsive.isMobile ? () {
                        context.read<ChatBloc>().add(ResetChatEvent());
                          Navigator.pop(context);
                      } : () {
                        context.read<ChatBloc>().add(ResetChatEvent());

                      },
                      borderColor:
                          !isDarkMode ? AppColors.black : AppColors.white,
                      textColor: !isDarkMode ? AppColors.black : AppColors.white,
                      prefixIcon: SvgPicture.asset(
                        "assets/icons/create_chat_icon.svg",
                        colorFilter: ColorFilter.mode(
                            !isDarkMode ? AppColors.black : AppColors.white,
                            BlendMode.srcIn),
                      ),
                      height: responsive.getResponsiveValue(
                        mobile: 40.0,
                        tablet: 45.0,
                        desktop: 50.0,
                      ),
                      width: responsive.getResponsiveValue(
                        mobile: double.infinity,
                        tablet: 300.0,
                        desktop: 377.0,
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      text: 'Start New Chat',
                      textStyle: responsive.getResponsiveValue(
                        mobile: AppTextStyles.medium14,
                        tablet: AppTextStyles.regular16,
                        desktop: AppTextStyles.regular18,
                      ),
                    ),
                  ),
                ],
              ),
  
              // Scrollable chat history
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Today section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Today',
                            style: responsive
                                .getResponsiveValue(
                                  mobile: AppTextStyles.medium16,
                                  tablet: AppTextStyles.medium18,
                                  desktop: AppTextStyles.regular20,
                                )
                                .copyWith(
                                  color: !isDarkMode
                                      ? AppColors.black
                                      : AppColors.white,
                                ),
                          ),
                        ),
                      ),
  
                      // Chat history
                      _buildChatHistoryItem(
                          'Strategy For Online E-Commerce Bus...', responsive),
                      _buildChatHistoryItem(
                          'Strategy For Online E-Commerce Bus...', responsive),
                      _buildChatHistoryItem(
                          'Strategy For Online E-Commerce Bus...', responsive),
  
                      // Yesterday section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Yesterday',
                            style: responsive
                                .getResponsiveValue(
                                  mobile: AppTextStyles.medium16,
                                  tablet: AppTextStyles.medium18,
                                  desktop: AppTextStyles.regular20,
                                )
                                .copyWith(
                                  color: !isDarkMode
                                      ? AppColors.black
                                      : AppColors.white,
                                ),
                          ),
                        ),
                      ),
  
                      // Chat history
                      _buildChatHistoryItem(
                          'Strategy For Online E-Commerce Bus...', responsive),
                      _buildChatHistoryItem(
                          'Strategy For Online E-Commerce Bus...', responsive),
                    ],
                  ),
                ),
              ),
  
              // Fixed elements at the bottom
              Column(
                children: [
                  // Account dropdown (if open)
                  if (_isDropdownOpen) _buildAccountDropdown(),
  
                  // Account section (always visible)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isDropdownOpen = !_isDropdownOpen;
                        });
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                !isDarkMode ? AppColors.black : AppColors.white,
                            radius: responsive.getResponsiveValue(
                              mobile: 12.0,
                              tablet: 13.0,
                              desktop: 14.0,
                            ),
                            child: Text('M',
                                style: TextStyle(
                                  color: !isDarkMode
                                      ? AppColors.white
                                      : AppColors.black,
                                )),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'motionizestudio@gmail.com',
                              style: responsive
                                  .getResponsiveValue(
                                    mobile: AppTextStyles.medium14,
                                    tablet: AppTextStyles.medium16,
                                    desktop: AppTextStyles.regular18,
                                  )
                                  .copyWith(
                                    color: !isDarkMode
                                        ? AppColors.black
                                        : AppColors.white,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            _isDropdownOpen
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  
    Widget _buildChatHistoryItem(String title, Responsive responsive) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            title,
            style: responsive.getResponsiveValue(
              mobile: AppTextStyles.medium14.copyWith(
                color: !isDarkMode ? AppColors.black : AppColors.white,
              ),
              tablet: AppTextStyles.medium16.copyWith(
                color: !isDarkMode ? AppColors.black : AppColors.white,
              ),
              desktop: AppTextStyles.regular18.copyWith(
                color: !isDarkMode ? AppColors.black : AppColors.white,
              ),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          contentPadding: responsive.getResponsiveValue(
            mobile: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            tablet: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            desktop: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          dense: true,
        ),
      );
    }
  
    Widget _buildChatHeader(
        BuildContext context, Responsive responsive, ChatState state) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      return Container(
        padding: responsive.getResponsiveValue(
          mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        decoration: BoxDecoration(
          color: !isDarkMode ? AppColors.lightTheme : AppColors.darkTheme,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.1),
          //     blurRadius: 4,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            // Show menu icon for mobile view
            if (responsive.isMobile)
              IconButton(
                icon: Icon(Icons.menu,
                    size: 20,
                    color: !isDarkMode ? AppColors.black : AppColors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            const SizedBox(
              width: 4,
            ),
  
            // Back arrow for larger screens
            if (!responsive.isMobile) ...[
              const Spacer(),
              // Center(
              //   child: Container(
              //     width: 200, // Make this wider to prevent accidental mouse exits
              //     child: MouseRegion(
              //       onEnter: (_) {
              //         setState(() {
              //           _isHoveringLogo = true;
              //         });
              //         if (!state.isFirstMessageSent) {
              //           context.read<ChatBloc>().add(ToggleSidebarEvent(true));
              //         }
              //       },
              //       onExit: (_) {
              //         setState(() {
              //           _isHoveringLogo = false;
              //         });
              //
              //         // Don't close immediately, add a small delay
              //         if (!state.isFirstMessageSent && !_keepSidebarOpen) {
              //           Future.delayed(Duration(milliseconds: 300), () {
              //             if (!_isHoveringLogo && !_keepSidebarOpen) {
              //               context.read<ChatBloc>().add(ToggleSidebarEvent(false));
              //             }
              //           });
              //         }
              //       },
              //       child: Row(
              //         children: [
              //           IconButton(
              //             icon: const Icon(Icons.arrow_back,
              //                 size: 20, color: AppColors.black),
              //             onPressed: () {
              //               // Toggle sidebar on click to make it stay open
              //               setState(() {
              //                 _keepSidebarOpen = !_keepSidebarOpen;
              //               });
              //             },
              //           ),
              //           const SizedBox(width: 8),
              //           Text(
              //             'New Chat',
              //             style: responsive.getResponsiveValue(
              //               mobile: AppTextStyles.medium20.copyWith(
              //                 color: !isDarkMode ? AppColors.black : AppColors.white,
              //               ),
              //               tablet: AppTextStyles.regular24.copyWith(
              //                 color: !isDarkMode ? AppColors.black : AppColors.white,
              //               ),
              //               desktop: AppTextStyles.regular28.copyWith(
              //                 color: !isDarkMode ? AppColors.black : AppColors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: Container(
                  width: 200, // Make this wider to prevent accidental mouse exits
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isHoveringLogo = true;
                      });
                      if (!state.isFirstMessageSent) {
                        context.read<ChatBloc>().add(ToggleSidebarEvent(true));
                      }
                    },
                    // onExit: (_) {
                    //   setState(() {
                    //     _isHoveringLogo = false;
                    //   });
                    //
                    //   // Don't close immediately, add a small delay
                    //   if (!state.isFirstMessageSent && !_keepSidebarOpen) {
                    //     Future.delayed(Duration(milliseconds: 300), () {
                    //       if (!_isHoveringLogo && !_keepSidebarOpen) {
                    //         context.read<ChatBloc>().add(ToggleSidebarEvent(false));
                    //       }
                    //     });
                    //   }
                    // },
                    child: Text(
                      'New Chat',
                      style: responsive.getResponsiveValue(
                        mobile: AppTextStyles.medium20.copyWith(
                          color: !isDarkMode ? AppColors.black : AppColors.white,
                        ),
                        tablet: AppTextStyles.regular24.copyWith(
                          color: !isDarkMode ? AppColors.black : AppColors.white,
                        ),
                        desktop: AppTextStyles.regular28.copyWith(
                          color: !isDarkMode ? AppColors.black : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
  
            // Just the title for mobile
            if (responsive.isMobile)
              Center(
                child: Text(
                  'New Chat',
                  style: AppTextStyles.medium20.copyWith(
                    color: !isDarkMode ? AppColors.black : AppColors.white,
                  ),
                ),
              ),
  
            const Spacer(),
            IconButton(
              icon: SvgPicture.asset("assets/icons/create_new_chat_icon.svg"
              ,height: responsive.getResponsiveValue(
                  mobile: 45.0,
                  tablet: 45.0,
                  desktop: 45.0,
                ),width: responsive.getResponsiveValue(
                    mobile: 45.0,
                    tablet: 45.0,
                    desktop: 45.0,
                  ),
              ),
              onPressed: () {},
              iconSize: responsive.getResponsiveValue(
                mobile: 12.0,
                tablet: 13.0,
                desktop: 14.0,
              ),
            ),
          ],
        ),
      );
    }
  
    Widget _buildChatMessages(
        BuildContext context, List<ChatMessage> messages, Responsive responsive) {
      final messagePadding = responsive.getResponsiveValue(
        mobile: const EdgeInsets.all(12),
        tablet: const EdgeInsets.all(14),
        desktop: const EdgeInsets.all(16),
      );
  
      return ListView.builder(
        padding: messagePadding,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return _buildMessageItem(message, responsive);
        },
      );
    }
  
    Widget _buildMessageItem(ChatMessage message, Responsive responsive) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      final avatarRadius = responsive.getResponsiveValue(
        mobile: 14.0,
        tablet: 15.0,
        desktop: 16.0,
      );
  
      final messageFontSize = responsive.getResponsiveValue(
        mobile: 13.0,
        tablet: 13.5,
        desktop: 18.0,
      );
  
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!message.isUser)
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: avatarRadius,
                child:
                    Icon(Icons.assistant, size: avatarRadius, color: Colors.grey),
              ),
            SizedBox(
                width: !message.isUser
                    ? responsive.getResponsiveValue(
                        mobile: 8.0,
                        tablet: 10.0,
                        desktop: 12.0,
                      )
                    : 0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: responsive.isMobile
                      ? message.isUser
                          ? 40.0
                          : 0
                      : message.isUser
                          ? 300.0
                          : 0,
                  right: responsive.isMobile
                      ? message.isUser
                          ? 0.0
                          : 40
                      : message.isUser
                          ? 0.0
                          : 300,
                ),
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color:
                            !isDarkMode ? AppColors.white : AppColors.darkTheme,
                        border: Border.all(
                          color: !isDarkMode ? AppColors.white : AppColors.white,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        message.text,
                        style: AppTextStyles.regular18.copyWith(
                          fontSize: messageFontSize,
                          color: !isDarkMode ? AppColors.black : AppColors.white,
                        ),
                      ),
                    ),
                    if (message.attachments != null) ...message.attachments!,
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  
    Widget _buildQuickActionButtons(BuildContext context, Responsive responsive) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      final buttonSpacing = responsive.getResponsiveValue(
        mobile: 6.0,
        tablet: 7.0,
        desktop: 8.0,
      );
  
      final buttonPadding = responsive.getResponsiveValue(
        mobile: const EdgeInsets.symmetric(vertical: 12),
        tablet: const EdgeInsets.symmetric(vertical: 14),
        desktop: const EdgeInsets.symmetric(vertical: 16),
      );
  
      return Container(
        padding: buttonPadding,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: buttonSpacing,
          runSpacing: buttonSpacing,
          children: [
            _buildActionButton(context, 'Get Advice', responsive),
            _buildActionButton(context, 'Make a Plan', responsive),
            _buildActionButton(context, 'Help me write', responsive),
            _buildActionButton(context, 'Summarize text', responsive),
          ],
        ),
      );
    }
  
    Widget _buildActionButton(
        BuildContext context, String label, Responsive responsive) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      final buttonFontSize = responsive.getResponsiveValue(
        mobile: 12.0,
        tablet: 13.0,
        desktop: 14.0,
      );
  
      final buttonPadding = responsive.getResponsiveValue(
        mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
  
      return OutlinedButton(
        onPressed: () {
          _messageController.text = label;
          // Optionally, you can also focus the text field
          FocusScope.of(context).requestFocus(FocusNode());
          const message =
              "Imagine that you are the manager and make me the list of summary points of this documents";
          context.read<ChatBloc>().add(SendMessageEvent(message));
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: !isDarkMode
                  ? AppColors.black.withOpacity(.5)
                  : AppColors.white.withOpacity(.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(13),
        ),
        child: Text(
          label,
          style: AppTextStyles.regular18.copyWith(
              fontWeight: FontWeight.w200,
              fontSize: buttonFontSize,
              color: !isDarkMode
                  ? AppColors.black.withOpacity(.5)
                  : AppColors.white.withOpacity(.5)),
        ),
      );
    }
  
    Widget _buildMessageInput(BuildContext context, Responsive responsive) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;
  
      final inputPadding = responsive.getResponsiveValue(
        mobile: const EdgeInsets.all(8),
        tablet: const EdgeInsets.all(10),
        desktop: const EdgeInsets.all(12),
      );
  
      final textFieldPadding = responsive.getResponsiveValue(
        mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
  
      final iconSize = responsive.getResponsiveValue(
        mobile: 18.0,
        tablet: 19.0,
        desktop: 20.0,
      );
  
      return Padding(
        padding: inputPadding,
        child: Container(
          padding: inputPadding,
          width: 813,
          decoration: BoxDecoration(
              color: AppColors.sendMessageColor,
              borderRadius: BorderRadiusDirectional.circular(51)
              ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    !isDarkMode ? AppColors.white : AppColors.darkTheme,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: iconSize,
                    color: !isDarkMode ? AppColors.black : AppColors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFileOptionsVisible = !_isFileOptionsVisible;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              // SizedBox(width: responsive.isMobile ? 8 : 12),
              Expanded(
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.enter) {
                        if (event.isShiftPressed) {
                          // Shift + Enter: Add a new line
                          _messageController.text += '\n';
                        } else {
                          // Enter: Send the message
                          if (_messageController.text.isNotEmpty) {
                            context
                                .read<ChatBloc>()
                                .add(SendMessageEvent(_messageController.text));
                            _messageController.clear();
                          }
                        }
                      }
                    }
                  },
                  child: TextField(
                    controller: _messageController,
                    style: AppTextStyles.regular16
                        .copyWith(color: AppColors.sendTextColor),
                    decoration: InputDecoration(
                      hintText: 'Ask anything...',
                      hintStyle: AppTextStyles.regular16
                          .copyWith(color: AppColors.sendTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.sendMessageColor,
                      contentPadding: textFieldPadding,
                    ),
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(width: responsive.isMobile ? 8 : 12),
              CircleAvatar(
                backgroundColor:
                    !isDarkMode ? AppColors.white : AppColors.darkTheme,
                child: IconButton(
                  iconSize: 28,
                  icon: SvgPicture.asset(
                    "assets/icons/send_message_icon.svg",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        !isDarkMode ? AppColors.black : AppColors.white,
                        BlendMode.srcIn),
                  ),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      context
                          .read<ChatBloc>()
                          .add(SendMessageEvent(_messageController.text));
                      _messageController.clear();
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  
    @override
    void dispose() {
      _messageController.dispose();
      super.dispose();
    }
  }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:silver_ai/services/shared_preference/shared_preference.dart';
import 'package:silver_ai/src/chat_bloc/get_all_chat_history_bloc.dart';
import 'package:silver_ai/src/chat_bloc/get_prompt_by_id_bloc.dart';
import 'package:silver_ai/src/setting_bloc/profile_bloc.dart';
import 'package:silver_ai/utils/colors.dart';
import 'package:silver_ai/utils/global_functions_variable.dart';
import 'package:silver_ai/utils/text_styles.dart';
import 'package:silver_ai/widget/app_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/chat_model.dart';
import '../../utils/responsive.dart';
import 'chat_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.isHistory = false});

  final bool isHistory;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  bool _isHoveringLogo = false;
  final bool _keepSidebarOpen = false;
  bool _isDropdownOpen = false;
  bool _isFileOptionsVisible = false;
  late IO.Socket socket;
  bool isBotTyping = false;
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> milanMessage = [];
  File? _selectedImage;
  bool _isLoadingSession = true;
  late AnimationController _animationController;
  int _currentTypingState = 0; // 0: Thinking, 1: Processing, 2: Generating
  
  // New variables for typing animation
  late AnimationController _typingAnimationController;
  Timer? _typingTimer;
  int _currentTypingIndex = -1; // Index of the message being typed
  int _typingSpeed = 30; // Milliseconds per character
  bool _enableTypingAnimation = true; // Enable/disable typing animation

  @override
  void initState() {
    initSocket();
    _refreshChatHistory(); // Initial load of chat history
    context.read<ProfileBloc>().add(ProfileRequested());
    if (kIsWeb) {
      checkAndRestoreSession();
    } else {
      _isLoadingSession = false;
    }

    // Initialize animation controller with longer duration for each state
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Total duration for all states
    )..addListener(() {
        if (_animationController.value < 0.15) {
          setState(() {
            _currentTypingState = 0; // Thinking
          });
        } else if (_animationController.value < 0.30) {
          setState(() {
            _currentTypingState = 1; // Processing
          });
        } else if (_animationController.value < 0.45) {
          setState(() {
            _currentTypingState = 2; // Generating
          });
        } else if (_animationController.value < 0.60) {
          setState(() {
            _currentTypingState = 3; // Loading
          });
        } else if (_animationController.value < 0.75) {
          setState(() {
            _currentTypingState = 4; // Analyzing
          });
        } else if (_animationController.value < 0.90) {
          setState(() {
            _currentTypingState = 5; // Summarizing
          });
        } else {
          setState(() {
            _currentTypingState = 6; // Almost there
          });
          // Stop the animation when it reaches "Almost there"
          if (_animationController.isAnimating) {
            _animationController.stop();
          }
        }
      });

    // Initialize typing animation controller
    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    super.initState();
  }

  Future<void> checkAndRestoreSession() async {
    final token = await StorageService.read(StorageService.authToken);
    if (token == null || token.isEmpty) {
      nextPage(context, '/auth');
    } else {
      setState(() {
        _isLoadingSession = false;
      });
    }
  }

  void initSocket() async {
    final token = await StorageService.read(StorageService.authToken);

    socket = IO.io('https://api.mithrex.in', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': token}
    });

    socket.connect();

    socket.onConnect((_) => print('Connected'));

    socket.on('send_message', (data) {
      print('Bot says: $data');
      if (mounted) {  // Check if widget is still mounted
        setState(() {
          isBotTyping = false;
          
          if (_enableTypingAnimation) {
            // Add the message with typing animation
            final newMessage = ChatMessage(
              text: data['message'],
              isUser: false,
              showImage: false,
              imageUrl: data['image_url'],
              timestamp: DateTime.now(),
              isTyping: true,
              typingProgress: 0,
            );
            
            milanMessage.add(newMessage);
            _currentTypingIndex = milanMessage.length - 1;
            
            // Start the typing animation
            _startTypingAnimation();
          } else {
            // Add the message without typing animation
            _addMessageWithoutTyping(
              data['message'],
              false,
              imageUrl: data['image_url'],
            );
          }
        });
        
        scrollToBottom();
      }
    });

    socket.onDisconnect((_) => print('Disconnected'));
    socket.onConnectError((err) => print('Connection Error: $err'));
    socket.onError((err) => print('Socket Error: $err'));
  }

  void _refreshChatHistory() {
    context.read<GetAllChatHistoryBloc>().add(GetAllChatHistoryRequested());
  }

  void sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        milanMessage.add(
          ChatMessage(
            text: text,
            showImage: false,
            isUser: true,
            timestamp: DateTime.now(),
          ),
        );
        isBotTyping = true;
        _messageController.clear();
        if (!isFirstMessageSent) {
          isFirstMessageSent = true;
          isSidebarVisible = true;
        }
      });

      socket.emit('send_message', {"message": text});
      scrollToBottom();

      // Start the animation sequence
      _animationController.reset();
      _animationController.forward();

      // Refresh chat history after sending message
      _refreshChatHistory();
    }
  }

  void imageSendMessage() async {
    final text = _messageController.text.trim();

    if (text.isNotEmpty && _selectedImage != null) {
      try {
        // Step 1: Upload image
        final result = await uploadImageToMithrex(_selectedImage!);

        final imageUrl = cleanImagePath(result!);

        print("image url return: $imageUrl");

        if (imageUrl != null) {
          // Step 2: Emit message + image URL to socket
          socket.emit('send_message', {
            "message": text,
            "image_url": imageUrl,
          });

          // Step 3: Update UI
          setState(() {
            milanMessage.add(
              ChatMessage(
                text: text,
                imageUrl: _selectedImage!.path,
                isUser: true,
                showImage: false,
                timestamp: DateTime.now(),
              ),
            );
            isBotTyping = true;
            _messageController.clear();
            _selectedImage = null;
            if (!isFirstMessageSent) {
              isFirstMessageSent = true;
              isSidebarVisible = true;
            }
          });

          scrollToBottom();

          // Start the animation sequence
          _animationController.reset();
          _animationController.forward();

          // Refresh chat history after sending message
          _refreshChatHistory();
        } else {
          print("❌ Image upload failed. No image URL returned.");
        }
      } catch (e) {
        print("❌ Error in imageSendMessage(): $e");
      }
    }
  }

  Future<String?> uploadImageToMithrex(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.mithrex.in/api/users/upload-document/'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
      ));

      var response = await request.send();

      log("image upload status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();

        print("image upload response body: $responseBody");

        var jsonResponse = jsonDecode(responseBody);
        _showCustomSnackBar("Image uploaded successfully");
        return jsonResponse["image_urls"]?[0]?["url"];
      } else {
        print("Upload failed: ${response.statusCode}");
        _showCustomSnackBar("Failed to upload image");
        return null;
      }
    } catch (e) {
      print("Upload exception: $e");
      _showCustomSnackBar("Error uploading image");
      return null;
    }
  }

  String cleanImagePath(String path) {
    return path.replaceFirst('/', '');
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startTypingAnimation() {
    if (_currentTypingIndex < 0 || _currentTypingIndex >= milanMessage.length) {
      return;
    }

    final message = milanMessage[_currentTypingIndex];
    final fullText = message.text;
    
    // Cancel any existing timer
    _typingTimer?.cancel();
    
    // Start the blinking cursor animation
    _typingAnimationController.repeat();
    
    // Start the typing animation
    _typingTimer = Timer.periodic(Duration(milliseconds: _typingSpeed), (timer) {
      if (mounted) {
        setState(() {
          final currentProgress = milanMessage[_currentTypingIndex].typingProgress;
          
          if (currentProgress < fullText.length) {
            // Update the typing progress
            milanMessage[_currentTypingIndex] = milanMessage[_currentTypingIndex].copyWith(
              typingProgress: currentProgress + 1,
            );
            scrollToBottom();
          } else {
            // Animation complete
            milanMessage[_currentTypingIndex] = milanMessage[_currentTypingIndex].copyWith(
              isTyping: false,
            );
            timer.cancel();
            _typingAnimationController.stop();
            _currentTypingIndex = -1;
          }
        });
      } else {
        timer.cancel();
        _typingAnimationController.stop();
      }
    });
  }

  void _addMessageWithoutTyping(String text, bool isUser, {String? imageUrl, bool showImage = false}) {
    setState(() {
      milanMessage.add(
        ChatMessage(
          text: text,
          isUser: isUser,
          showImage: showImage,
          imageUrl: imageUrl,
          timestamp: DateTime.now(),
          isTyping: false,
          typingProgress: text.length,
        ),
      );
    });
  }

  bool isFirstMessageSent = false;
  bool isSidebarVisible = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_isLoadingSession) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: isDarkMode ? AppColors.white : AppColors.black,
                  strokeWidth: 5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Loading...",
                style: AppTextStyles.regular18.copyWith(
                  color: isDarkMode ? AppColors.white : AppColors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BlocConsumer<GetPromptByIdBloc, GetPromptByIdState>(
      listener: (context, state) {
        if (state is GetPromptByIdSuccess) {
          state.response.messages!.map(
            (e) {
              setState(() {
                milanMessage.add(
                  ChatMessage(
                    text: e.userMessage.toString(),
                    isUser: true,
                    showImage: e.imageUrl != null ? true : false,
                    imageUrl: e.imageUrl != null
                        ? 'https://api.mithrex.in/${e.imageUrl}'
                        : e.imageUrl,
                    timestamp: e.createdAt!,
                    isTyping: false,
                    typingProgress: e.userMessage.toString().length,
                  ),
                );
                milanMessage.add(
                  ChatMessage(
                    text: e.aiResponse.toString(),
                    isUser: false,
                    showImage: false,
                    timestamp: e.responseTime!,
                    isTyping: false,
                    typingProgress: e.aiResponse.toString().length,
                  ),
                );

                isFirstMessageSent = true;
              });
            },
          ).toList();

          scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state is GetPromptByIdSuccess) {
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
                            ? Drawer(
                                child:
                                    _buildSidebar(context, responsive, state))
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
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: (isSidebarVisible ||
                                                  isFirstMessageSent)
                                              ? responsive.responsiveWidth(
                                                  mobile: 0,
                                                  tablet: 220,
                                                  desktop: 260,
                                                )
                                              : 0,
                                          child: (isSidebarVisible ||
                                                  isFirstMessageSent)
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
                                                child:
                                                    milanMessage.length <= 1 &&
                                                            !isFirstMessageSent
                                                        ? _buildWelcomeMessage()
                                                        : _buildChatMessages(
                                                            context,
                                                            milanMessage,
                                                            responsive),
                                              ),

                                              // Quick action buttons
                                              if (milanMessage.isEmpty &&
                                                  !isFirstMessageSent)
                                                _buildQuickActionButtons(
                                                    context, responsive),

                                              // Message input - always at bottom
                                              _buildMessageInput(
                                                  context, responsive),
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
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            // Adjust based on your message input height
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: _buildFileOptionsOverlay(
                                                  responsive),
                                            ),
                                          )
                                        : Positioned(
                                            bottom: 80,
                                            // Adjust based on your message input height
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child:
                                                  _buildFileMobileOptionsRow(),
                                            ),
                                          ),
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
        } else {
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
                            ? Drawer(
                                child:
                                    _buildSidebar(context, responsive, state))
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
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: (isSidebarVisible ||
                                                  isFirstMessageSent)
                                              ? responsive.responsiveWidth(
                                                  mobile: 0,
                                                  tablet: 220,
                                                  desktop: 260,
                                                )
                                              : 0,
                                          child: (isSidebarVisible ||
                                                  isFirstMessageSent)
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
                                                child:
                                                    milanMessage.length <= 1 &&
                                                            !isFirstMessageSent
                                                        ? _buildWelcomeMessage()
                                                        : _buildChatMessages(
                                                            context,
                                                            milanMessage,
                                                            responsive),
                                              ),

                                              // Quick action buttons
                                              if (milanMessage.isEmpty &&
                                                  !isFirstMessageSent)
                                                _buildQuickActionButtons(
                                                    context, responsive),

                                              // Message input - always at bottom
                                              _buildMessageInput(
                                                  context, responsive),
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
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            // Adjust based on your message input height
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: _buildFileOptionsOverlay(
                                                  responsive),
                                            ),
                                          )
                                        : Positioned(
                                            bottom: 80,
                                            // Adjust based on your message input height
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child:
                                                  _buildFileMobileOptionsRow(),
                                            ),
                                          ),
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
      },
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
            onTap: () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                setState(() {
                  _selectedImage = File(pickedFile.path);
                });
              }

              setState(() {
                _isFileOptionsVisible = false;
              });
            },
          ),
          _buildFileMobileOptionItem(
            icon: Icons.folder_outlined,
            label: "Files",
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );

              if (result != null && result.files.single.path != null) {
                setState(() {
                  _selectedImage = File(result.files.single.path!);
                });
              }

              setState(() {
                _isFileOptionsVisible = false;
              });
            },
          ),
          _buildFileMobileOptionItem(
            icon: Icons.image_outlined,
            label: "Images",
            onTap: () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _selectedImage = File(pickedFile.path);
                });
              }

              setState(() {
                _isFileOptionsVisible = false;
              });
            },
          ),
        ],
      ),
    );
  }

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
    return Positioned(
      bottom: 100, // Position above the input field
      left: 110,
      right: 0,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: isSidebarVisible ? 250.0 : 0),
          child: Container(
            width: responsive.isMobile
                ? MediaQuery.of(context).size.width * 0.9
                : MediaQuery.of(context).size.width * 0.5,
            // Match input field width (50% for web)
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFileOptionItem(
                  icon: "assets/images/chat_files_option.png",
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        _selectedImage = File(result.files.single.path!);
                        _isFileOptionsVisible = false;
                      });
                    }
                  },
                ),
                _buildFileOptionItem(
                  icon: "assets/images/images_option.png",
                  onTap: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                        _isFileOptionsVisible = false;
                      });
                    }
                  },
                ),
                _buildFileOptionItem(
                  icon: "assets/images/camera_option.png",
                  onTap: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                        _isFileOptionsVisible = false;
                      });
                    }
                  },
                ),
                _buildFileOptionItem(
                  icon: "assets/images/voice_option.png",
                  onTap: () {
                    setState(() {
                      _isFileOptionsVisible = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileOptionItem(
      {required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileSuccess) {
                    return Text(
                      state.response.user!.userName.toString(),
                      style: AppTextStyles.regular24.copyWith(
                        fontWeight: FontWeight.w100,
                        color: !isDarkMode ? AppColors.black : AppColors.white,
                      ),
                    );
                  } else {
                    return Text(
                      "Hi User!",
                      style: AppTextStyles.regular24.copyWith(
                        fontWeight: FontWeight.w100,
                        color: !isDarkMode ? AppColors.black : AppColors.white,
                      ),
                    );
                  }
                },
              ),
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
                    log("Button tapped");

                    try {
                      nextPage(context, '/settings');
                    } catch (e) {
                      log('Navigation error: $e');
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
                  () async {
                    await StorageService.remove(StorageService.authToken);
                    // await GoogleSignIn().signOut();
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
    // context.read<GetAllChatHistoryBloc>().add(GetAllChatHistoryRequested());

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
                      Expanded(
                        child: Text(
                          'Silver AI',
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
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isSidebarVisible = false;
                          });
                          context
                              .read<ChatBloc>()
                              .add(ToggleSidebarEvent(false));
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/expand_icon.svg",
                          colorFilter: ColorFilter.mode(
                            !isDarkMode ? AppColors.black : AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Scrollable chat history
            Expanded(
              child:
                  BlocConsumer<GetAllChatHistoryBloc, GetAllChatHistoryState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is GetAllChatHistoryLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: !isDarkMode ? AppColors.black : AppColors.white,
                      ),
                    );
                  } else if (state is GetAllChatHistorySuccess) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Today section
                          Visibility(
                            visible:
                                state.response.data!.today!.prompts!.isNotEmpty,
                            child: Padding(
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
                          ),

                          ...state.response.data!.today!.prompts!.map((e) {
                            return GestureDetector(
                              onTap: () {
                                context.read<GetPromptByIdBloc>().add(
                                      GetPromptByIdRequested(
                                        promptId: e.promptId.toString(),
                                        limit: 10000,
                                        offset: 1,
                                      ),
                                    );
                                nextReplacePage(context, '/chat',
                                    isHistory: true);
                              },
                              child: _buildChatHistoryItem(
                                  e.title.toString(), responsive),
                            );
                          }),

                          // Yesterday section
                          Visibility(
                            visible: state
                                .response.data!.yesterday!.prompts!.isNotEmpty,
                            child: Padding(
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
                          ),

                          ...state.response.data!.yesterday!.prompts!.map((e) {
                            return GestureDetector(
                              onTap: () {
                                context.read<GetPromptByIdBloc>().add(
                                      GetPromptByIdRequested(
                                        promptId: e.promptId.toString(),
                                        limit: 10000,
                                        offset: 1,
                                      ),
                                    );
                                nextReplacePage(context, '/chat',
                                    isHistory: true);
                              },
                              child: _buildChatHistoryItem(
                                  e.title.toString(), responsive),
                            );
                          }),

                          // last 7 days
                          Visibility(
                            visible: state
                                .response.data!.last7Days!.prompts!.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Last 7 Days',
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
                          ),

                          ...state.response.data!.last7Days!.prompts!.map((e) {
                            return GestureDetector(
                              onTap: () {
                                context.read<GetPromptByIdBloc>().add(
                                      GetPromptByIdRequested(
                                        promptId: e.promptId.toString(),
                                        limit: 10000,
                                        offset: 1,
                                      ),
                                    );
                                nextReplacePage(context, '/chat',
                                    isHistory: true);
                              },
                              child: _buildChatHistoryItem(
                                  e.title.toString(), responsive),
                            );
                          }),

                          // last 30 days

                          Visibility(
                            visible: state
                                .response.data!.last30Days!.prompts!.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Last 30 Days',
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
                          ),

                          ...state.response.data!.last30Days!.prompts!.map((e) {
                            return GestureDetector(
                              onTap: () {
                                context.read<GetPromptByIdBloc>().add(
                                      GetPromptByIdRequested(
                                        promptId: e.promptId.toString(),
                                        limit: 10000,
                                        offset: 1,
                                      ),
                                    );
                                nextReplacePage(context, '/chat',
                                    isHistory: true);
                              },
                              child: _buildChatHistoryItem(
                                  e.title.toString(), responsive),
                            );
                          }),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Chat History",
                        style: AppTextStyles.regular16.copyWith(
                          color:
                              !isDarkMode ? AppColors.black : AppColors.white,
                        ),
                      ),
                    );
                  }
                },
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
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileSuccess) {
                              final name = getFirstChar(
                                  state.response.user!.email.toString());

                              return CircleAvatar(
                                backgroundColor: !isDarkMode
                                    ? AppColors.black
                                    : AppColors.white,
                                radius: responsive.getResponsiveValue(
                                  mobile: 12.0,
                                  tablet: 13.0,
                                  desktop: 14.0,
                                ),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    color: !isDarkMode
                                        ? AppColors.white
                                        : AppColors.black,
                                  ),
                                ),
                              );
                            } else {
                              return const Center();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state is ProfileSuccess) {
                                return Text(
                                  state.response.user!.email.toString(),
                                  style: responsive
                                      .getResponsiveValue(
                                        mobile: AppTextStyles.medium14,
                                        tablet: AppTextStyles.medium16,
                                        desktop: AppTextStyles.regular18,
                                      )
                                      .copyWith(
                                        color: isDarkMode
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              } else {
                                return const Center();
                              }
                            },
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

  String getFirstChar(String value) {
    if (value.isNotEmpty) {
      return value[0];
    } else {
      return '';
    }
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
    print("_isHoveringLogo :: $_isHoveringLogo");
    return Container(
      padding: responsive.getResponsiveValue(
        mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      decoration: BoxDecoration(
        color: !isDarkMode ? AppColors.lightTheme : AppColors.darkTheme,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const SizedBox(width: 4),

          // Logo, Menu Icon and New Chat for larger screens
          if (!responsive.isMobile) ...[
            IconButton(
              icon: Icon(Icons.menu,
                  size: 24,
                  color: !isDarkMode ? AppColors.black : AppColors.white),
              onPressed: () {
                setState(() {
                  isSidebarVisible = !isSidebarVisible;
                });
                context
                    .read<ChatBloc>()
                    .add(ToggleSidebarEvent(isSidebarVisible));
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
          ],

          // Center the New Chat text
          Expanded(
            child: Center(
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

          // New Chat button
          Container(
            constraints: BoxConstraints(
              maxWidth: responsive.getResponsiveValue(
                mobile: 45.0,
                tablet: 45.0,
                desktop: 45.0,
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/create_new_chat_icon.svg",
                height: responsive.getResponsiveValue(
                  mobile: 45.0,
                  tablet: 45.0,
                  desktop: 45.0,
                ),
                width: responsive.getResponsiveValue(
                  mobile: 45.0,
                  tablet: 45.0,
                  desktop: 45.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  isFirstMessageSent = false;
                  isSidebarVisible = false;
                  milanMessage.clear();
                });
                nextReplacePage(context, '/chat');
              },
              iconSize: responsive.getResponsiveValue(
                mobile: 12.0,
                tablet: 13.0,
                desktop: 14.0,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
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
      desktop: const EdgeInsets.symmetric(horizontal: 200, vertical: 16),
    );

    return ListView.builder(
      controller: _scrollController,
      padding: messagePadding,
      itemCount: messages.length + (isBotTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isBotTyping) {
          return _buildTypingAnimation(responsive);
        }
        final message = messages[index];
        return _buildMessageItem(message, responsive);
      },
    );
  }

  Widget _buildTypingAnimation(Responsive responsive) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final avatarRadius = responsive.getResponsiveValue(
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Bot avatar
          // CircleAvatar(
          //   backgroundColor: Colors.grey[300],
          //   radius: avatarRadius,
          //   child:
          //       Icon(Icons.assistant, size: avatarRadius, color: Colors.grey),
          // ),
          SizedBox(
            width: responsive.getResponsiveValue(
              mobile: 8.0,
              tablet: 10.0,
              desktop: 12.0,
            ),
          ),
          // Typing animation container
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 0,
                right: responsive.isMobile ? 40.0 : 300.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    // child: Image.asset(
                    //   'assets/images/chat_animation.gif',
                    //   color: Theme.of(context).brightness == Brightness.light
                    //       ? AppColors.darkTheme
                    //       : AppColors.lightTheme,
                    //   height: 20,
                    //   width: 60,
                    //   fit: BoxFit.contain,
                    // ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _getTypingText(),
                          style: TextStyle(
                            fontSize: 15,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 15, // Matches text height approx
                          width: 18,
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypingText() {
    switch (_currentTypingState) {
      case 0:
        return 'Thinking';
      case 1:
        return 'Processing';
      case 2:
        return 'Generating';
      case 3:
        return 'Loading';
      case 4:
        return 'Analyzing';
      case 5:
        return 'Summarizing';
      case 6:
        return 'Almost there';
      default:
        return 'Thinking';
    }
  }

  Widget _buildMessageItem(ChatMessage message, Responsive responsive) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get the text to display based on typing progress
    String displayText = message.text;
    if (message.isTyping) {
      displayText = message.text.substring(0, message.typingProgress);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: responsive.isMobile  ?    MediaQuery.of(context).size.width * 0.7 :
              responsive.isTablet ? MediaQuery.of(context).size.width * 0.6 :
              MediaQuery.of(context).size.width * 0.5,
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: message.showImage
                      ? Image.network(message.imageUrl!,
                          width: 220, height: 120, fit: BoxFit.cover)
                      : Image.file(File(message.imageUrl!),
                          width: 220, height: 120, fit: BoxFit.cover),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkTheme : AppColors.white,
                border: Border.all(
                    color: !isDarkMode ? AppColors.white : AppColors.white),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: displayText.contains('```')
                        ? _buildFormattedMessageText(
                            displayText, isDarkMode ? Colors.white : Colors.black)
                        : SelectableText(
                            displayText,
                            style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: isDarkMode ? Colors.white : Colors.black),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedMessageText(String text, Color textColor) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final parts = text.split('```');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(parts.length, (index) {
        final content = parts[index].trim();
        final isCode = index % 2 == 1;

        if (isCode) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12, bottom: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SelectableText(
                  content,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(50, 30),
                    backgroundColor:
                        isDarkMode ? AppColors.darkTheme : Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: isDarkMode
                          ? const BorderSide(color: Colors.white30)
                          : const BorderSide(color: Colors.black12),
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    _showCustomSnackBar("Code copied to clipboard");
                  },
                  child: Text(
                    "Copy",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SelectableText(
              content,
              style: TextStyle(fontSize: 15, color: textColor, height: 1.5),
            ),
          );
        }
      }),
    );
  }

  Widget _buildQuickActionButtons(BuildContext context, Responsive responsive) {
    Theme.of(context);

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

    // Calculate the available width based on sidebar visibility
    final availableWidth = MediaQuery.of(context).size.width -
        (isSidebarVisible
            ? responsive.responsiveWidth(
                mobile: 0,
                tablet: 220,
                desktop: 260,
              )
            : 0);

    return Center(
      child: Container(
        padding: buttonPadding,
        constraints: BoxConstraints(
          maxWidth:
              responsive.isDesktop ? availableWidth * 0.8 : double.infinity,
        ),
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

    responsive.getResponsiveValue(
      mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      tablet: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );

    return OutlinedButton(
      onPressed: () {
        _messageController.text = label;
        // Optionally, you can also focus the text field
        FocusScope.of(context).requestFocus(FocusNode());
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
      desktop: const EdgeInsets.symmetric(horizontal: 200, vertical: 12),
    );
    final innerInputPadding = responsive.getResponsiveValue(
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(10),
      desktop: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

    return Center(
      child: Padding(
        padding: inputPadding,
        child: Container(
          padding: innerInputPadding,
          width: responsive.isMobile
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: AppColors.sendMessageColor,
            borderRadius: _selectedImage != null
                ? BorderRadiusDirectional.circular(14)
                : BorderRadiusDirectional.circular(51),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 7, left: 5, top: 5, right: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            height: 65,
                            width: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Expanded(
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (RawKeyEvent event) {
                        if (event is RawKeyDownEvent) {
                          if (event.logicalKey == LogicalKeyboardKey.enter) {
                            if (event.isShiftPressed) {
                              _messageController.text += '\n';
                            } else {
                              if (_messageController.text.isNotEmpty ||
                                  _selectedImage != null) {
                                if (_selectedImage != null) {
                                  imageSendMessage();
                                  _messageController.clear();
                                  scrollToBottom();
                                } else {
                                  sendMessage();
                                  _messageController.clear();
                                  scrollToBottom();
                                }
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
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {
                        if (_messageController.text.isNotEmpty ||
                            _selectedImage != null) {
                          if (_selectedImage != null) {
                            imageSendMessage();
                            scrollToBottom();
                            _messageController.clear();
                            setState(() {
                              isFirstMessageSent = true;
                              isSidebarVisible = true;
                            });
                          } else {
                            sendMessage();
                            scrollToBottom();
                            _messageController.clear();
                            setState(() {
                              isFirstMessageSent = true;
                              isSidebarVisible = true;
                            });
                          }
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomSnackBar(String message) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: isDarkMode ? AppColors.darkTheme : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: isDarkMode ? Colors.white : AppColors.black,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.regular14.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    socket.disconnect();  // Disconnect socket when widget is disposed
    socket.off('send_message');  // Remove event listeners
    socket.off('disconnect');
    socket.off('connect_error');
    socket.off('error');
    _messageController.dispose();
    _animationController.dispose();
    _typingAnimationController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isBotTyping) {
      _animationController.forward(); // Use forward() instead of repeat()
    } else {
      _animationController.stop();
    }
  }

  // Method to toggle typing animation
  void _toggleTypingAnimation() {
    setState(() {
      _enableTypingAnimation = !_enableTypingAnimation;
    });
  }

  // Method to adjust typing speed
  void _setTypingSpeed(int speedInMs) {
    setState(() {
      _typingSpeed = speedInMs;
    });
  }
}

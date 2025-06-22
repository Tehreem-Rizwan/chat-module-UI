import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final Function(bool) onTyping;
  final bool enabled;

  const ChatInput({
    Key? key,
    required this.onSend,
    required this.onTyping,
    this.enabled = true,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  bool _isRecording = false;
  bool _showAttachmentOptions = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onTextChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onTextChanged() {
    widget.onTyping(_controller.text.isNotEmpty);
    setState(() {}); // triggers send button animation
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  void _toggleAttachmentOptions() {
    setState(() {
      _showAttachmentOptions = !_showAttachmentOptions;
    });

    if (_showAttachmentOptions) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (!_isRecording) {
      // Mock sending a voice message
      widget.onSend('[Voice Message]');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get _showSendButton => _controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final floatingSend = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: _showSendButton
          ? FloatingActionButton(
              key: const ValueKey('send'),
              heroTag: 'chatSend',
              mini: true,
              backgroundColor: AppTheme.primaryColor,
              elevation: 2,
              onPressed: widget.enabled ? _handleSend : null,
              child: const Icon(Icons.send, color: Colors.white),
            )
          : FloatingActionButton(
              key: const ValueKey('mic'),
              heroTag: 'chatMic',
              mini: true,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.85),
              elevation: 2,
              onPressed: widget.enabled ? _toggleVoiceRecording : null,
              child: _isRecording
                  ? AnimatedPulse(
                      child: const Icon(Icons.mic, color: Colors.redAccent),
                    )
                  : const Icon(Icons.mic, color: Colors.white),
            ),
    );

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated attachment row
          SizeTransition(
            sizeFactor: _animationController,
            axisAlignment: -1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentButton(
                      Icons.image_rounded, 'Image', Colors.purple),
                  _buildAttachmentButton(
                      Icons.camera_alt_rounded, 'Camera', Colors.red),
                  _buildAttachmentButton(
                      Icons.insert_drive_file_rounded, 'File', Colors.blue),
                  _buildAttachmentButton(
                      Icons.emoji_emotions_rounded, 'Emoji', Colors.amber),
                ],
              ),
            ),
          ),

          // Input bar
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(26),
              color: Colors.white,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  children: [
                    // Attachment toggle
                    IconButton(
                      icon: Icon(
                        _showAttachmentOptions ? Icons.close : Icons.add,
                        color: _showAttachmentOptions
                            ? AppTheme.error
                            : AppTheme.textLightSecondary,
                      ),
                      splashRadius: 24,
                      onPressed:
                          widget.enabled ? _toggleAttachmentOptions : null,
                    ),
                    // Text input
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: widget.enabled
                              ? 'Type a message...'
                              : 'Connecting to chat...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                        enabled: widget.enabled && !_isRecording,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    // Emoji shortcut (optional, can be expanded with picker)
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      color: AppTheme.textLightSecondary,
                      splashRadius: 24,
                      onPressed: widget.enabled
                          ? () {
                              // Future: show emoji picker
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Emoji picker coming soon!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          : null,
                    ),
                    // Animated floating send/mic
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 2),
                      child: floatingSend,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isRecording)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildRecordingButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: widget.enabled
          ? () {
              _toggleAttachmentOptions();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label feature coming soon!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildRecordingButton() {
    return AnimatedPulse(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 6,
        ),
        icon: const Icon(Icons.stop_rounded),
        label: const Text('Stop Recording'),
        onPressed: _toggleVoiceRecording,
      ),
    );
  }
}

class AnimatedPulse extends StatefulWidget {
  final Widget child;
  const AnimatedPulse({required this.child, Key? key}) : super(key: key);

  @override
  State<AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: 1 + (_controller.value * 0.08),
        child: Opacity(
          opacity: 0.85 + (_controller.value * 0.15),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

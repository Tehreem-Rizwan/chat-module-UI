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

class _ChatInputState extends State<ChatInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isRecording = false;
  bool _showVoiceRecordButton = false;
  bool _showAttachmentOptions = false;

  @override
  void initState() {
    super.initState();
    
    _controller.addListener(_onTextChanged);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _onTextChanged() {
    // Show/hide voice button based on text input
    final shouldShowVoice = _controller.text.isEmpty;
    if (_showVoiceRecordButton != shouldShowVoice) {
      setState(() {
        _showVoiceRecordButton = shouldShowVoice;
      });
    }
    
    // Notify parent about typing status
    widget.onTyping(_controller.text.isNotEmpty);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Attachment options
        SizeTransition(
          sizeFactor: _animation,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentButton(Icons.image, 'Image', Colors.purple),
                _buildAttachmentButton(Icons.camera_alt, 'Camera', Colors.red),
                _buildAttachmentButton(Icons.mic, 'Voice', Colors.orange),
                _buildAttachmentButton(Icons.emoji_emotions, 'Emoji', Colors.amber),
              ],
            ),
          ),
        ),
        
        // Main input bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Attachment button
              IconButton(
                icon: Icon(
                  _showAttachmentOptions
                      ? Icons.close
                      : Icons.add_circle_outline,
                  color: _showAttachmentOptions
                      ? AppTheme.error
                      : AppTheme.textLightSecondary,
                ),
                onPressed: widget.enabled ? _toggleAttachmentOptions : null,
              ),
              
              // Text input field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? Colors.grey.shade100
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: widget.enabled
                                  ? 'Type a message...'
                                  : 'Connecting to chat...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              isDense: true,
                            ),
                            enabled: widget.enabled,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          color: AppTheme.textLightSecondary,
                          onPressed: widget.enabled
                              ? () {
                                  // Show emoji picker (not implemented for demo)
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Send or voice record button
              _isRecording
                  ? _buildRecordingButton()
                  : _showVoiceRecordButton
                      ? IconButton(
                          icon: const Icon(Icons.mic),
                          color: AppTheme.primaryColor,
                          onPressed: widget.enabled
                              ? _toggleVoiceRecording
                              : null,
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          color: AppTheme.primaryColor,
                          onPressed: widget.enabled
                              ? _handleSend
                              : null,
                        ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        _toggleAttachmentOptions();
        // Mock the action (not implemented for demo)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label feature coming soon!'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingButton() {
    return GestureDetector(
      onTap: _toggleVoiceRecording,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.stop,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              'Stop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

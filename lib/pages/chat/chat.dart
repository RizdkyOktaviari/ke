import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/message_provider.dart';
import '../../models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        context.read<MessageProvider>().fetchMessages(token);
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent, color: Colors.blue),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Support'),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final token = context.read<AuthProvider>().token;
              if (token != null) {
                context.read<MessageProvider>().fetchMessages(token);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessageProvider>(
              builder: (context, messageProvider, child) {
                if (messageProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (messageProvider.error != null) {
                  return Center(child: Text(messageProvider.error!));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  reverse: true,
                  itemCount: messageProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = messageProvider.messages[index];
                    final userId = context.read<AuthProvider>().user?.id;
                    final isUserMessage = message.senderId == userId;

                    return isUserMessage
                        ? _buildUserMessage(message)
                        : _buildAdminMessage(message);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Consumer<MessageProvider>(
                  builder: (context, messageProvider, child) {
                    return FloatingActionButton(
                      onPressed: () async {
                        if (_messageController.text.isNotEmpty) {
                          final token = context.read<AuthProvider>().token;
                          if (token != null) {
                            await messageProvider.sendMessage(
                              token,
                              _messageController.text,
                            );
                            _messageController.clear();
                            _scrollToTop();
                          }
                        }
                      },
                      child: Icon(Icons.send),
                      mini: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 250),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.content,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  message.createdAt.substring(11, 16),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAdminMessage(Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 250,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.content),
                SizedBox(height: 4),
                Text(
                  '09:40',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

}

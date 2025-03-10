import 'package:flutter/material.dart';
import 'package:jop_project/Models/chat/chat_model.dart';
import 'package:jop_project/Providers/Caht-firebase_database/chat_firebase_database_provider.dart';
import 'package:jop_project/Screens/ChatScreen/chat_screen.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  final String userId; // استبدل بمعرف المستخدم الفعلي
  const ChatListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: chatProvider.getChatsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chats available'));
          } else {
            List<ChatModel> chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                ChatModel chat = chats[index];
                return ListTile(
                  title:
                      Text('Chat with Company ${chat.chatId!.split('_')[1]}'),
                  subtitle: Text('Last message: ${chat.messages!.last.text}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatId: chat.chatId!),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

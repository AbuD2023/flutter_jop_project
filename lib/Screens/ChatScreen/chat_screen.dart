import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jop_project/Models/chat/messageModel.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:jop_project/Models/searcher_model.dart';
import 'package:jop_project/Providers/Caht-firebase_database/chat_firebase_database_provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final CompanyModel? companyModel;
  final SearchersModel? searchersModel;
  final String chatId;

  const ChatScreen({
    super.key,
    this.companyModel,
    this.searchersModel,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Background(
      userImage: widget.companyModel?.img ?? widget.searchersModel?.img ?? '',
      userName: widget.companyModel?.nameCompany ??
          widget.searchersModel?.fullName ??
          '',
      isCompany: false,
      showListNotiv: true,
      title: widget.companyModel?.nameCompany ??
          widget.searchersModel?.fullName ??
          '______',
      child: Responsive(
        mobile: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(
                    widget.companyModel?.nameCompany ??
                        widget.searchersModel?.fullName ??
                        '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  leading: const Icon(Icons.person),
                  trailing: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: Text(
                        '12:00',
                        style: TextStyle(fontSize: 11),
                        textDirection: TextDirection.ltr,
                      )),
                      Expanded(
                          child: Text(
                        'Typing ...',
                        style: TextStyle(fontSize: 11),
                        textDirection: TextDirection.ltr,
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: chatProvider.getMessagesStream(
                    widget.chatId), // استخدام Provider للحصول على Stream
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    log('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No messages available'));
                  } else {
                    List<MessageModel> messages = snapshot.data!;

                    // ترتيب الرسائل من الأحدث إلى الأقدم
                    messages
                        .sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        MessageModel message = messages[index];
                        return MessageBubble(
                            message: message,
                            isMy: (widget.companyModel?.id ==
                                    int.parse(message.senderId!))
                                ? true
                                : (widget.searchersModel?.id ==
                                        int.parse(message.senderId!))
                                    ? true
                                    : false);
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: kPrimaryColor,
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        String messageId = chatProvider.databaseReference
                            .child('chats/${widget.chatId}/messages')
                            .push()
                            .key!;
                        MessageModel message = MessageModel(
                          messageId: messageId,
                          senderId: widget.companyModel != null
                              ? Provider.of<SearcherSigninLoginProvider>(
                                      context,
                                      listen: false)
                                  .currentSearcher
                                  ?.id
                                  .toString()
                              : widget.searchersModel != null
                                  ? Provider.of<CompanySigninLoginProvider>(
                                          context,
                                          listen: false)
                                      .currentCompany
                                      ?.id
                                      .toString()
                                  : '11', // استبدل بمعرف المستخدم الفعلي
                          text: _messageController.text,
                          timestamp: DateTime.now(),
                        );
                        chatProvider.addMessage(widget.chatId, message);
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        desktop: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: chatProvider.getMessagesStream(
                    widget.chatId), // استخدام Provider للحصول على Stream
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No messages available'));
                  } else {
                    List<MessageModel> messages = snapshot.data!;

                    // ترتيب الرسائل من الأحدث إلى الأقدم
                    messages
                        .sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        MessageModel message = messages[index];
                        return MessageBubble(
                            message: message,
                            isMy: (widget.companyModel != null) ? true : false);
                        // ListTile(
                        //   title: Text(message.text!),
                        //   subtitle: Text(
                        //       '${message.senderId} - ${message.timestamp}'),
                        // );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter your message here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: kPrimaryColor,
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        String messageId = chatProvider.databaseReference
                            .child('chats/${widget.chatId}/messages')
                            .push()
                            .key!;
                        MessageModel message = MessageModel(
                          messageId: messageId,
                          senderId: widget.companyModel != null
                              ? Provider.of<SearcherSigninLoginProvider>(
                                      context)
                                  .currentSearcher
                                  ?.id
                                  .toString()
                              : Provider.of<CompanySigninLoginProvider>(context)
                                  .currentCompany
                                  ?.id
                                  .toString(), // استبدل بمعرف المستخدم الفعلي
                          text: _messageController.text,
                          timestamp: DateTime.now(),
                        );
                        chatProvider.addMessage(widget.chatId, message);
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMy;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMy,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMy ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMy ? kPrimaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text.toString(),
              style: TextStyle(
                color: isMy ? Colors.white : Colors.black,
              ),
            ),
            Text(
              '${DateTime.parse(message.timestamp.toString()).hour.toString().padLeft(2, '0')}:${DateTime.parse(message.timestamp.toString()).minute.toString().padLeft(2, '0')} ${DateTime.parse(message.timestamp.toString()).hour}:${DateTime.parse(message.timestamp.toString()).minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: isMy ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

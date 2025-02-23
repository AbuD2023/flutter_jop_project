import 'package:flutter/material.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/responsive.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Background(
      title: widget.userName,
      child: Responsive(
        mobile: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const ListTile(
                  title: Text(
                    'data',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Icon(Icons.person),
                  trailing: Column(
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
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(message: messages[index]);
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
                        setState(() {
                          messages.add(ChatMessage(
                            text: _messageController.text,
                            isMe: true,
                          ));
                          _messageController.clear();
                        });
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
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(message: messages[index]);
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
                        setState(() {
                          messages.add(ChatMessage(
                            text: _messageController.text,
                            isMe: true,
                          ));
                          _messageController.clear();
                        });
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

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isMe,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: message.isMe ? kPrimaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black,
              ),
            ),
            Text(
              '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: message.isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

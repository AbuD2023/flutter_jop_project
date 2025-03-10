import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jop_project/Models/chat/chat_model.dart';
import 'package:jop_project/Models/chat/messageModel.dart';

class ChatProvider with ChangeNotifier {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  DatabaseReference get databaseReference => _databaseReference;

  List<ChatModel> _chats = [];

  List<ChatModel> get chats => _chats;

  // جلب الدردشات باستخدام Stream
  Stream<List<ChatModel>> getChatsStream(String userId) {
    return _databaseReference
        .child('chats')
        .orderByChild('searcherId')
        .equalTo(userId)
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> chatsData =
            event.snapshot.value as Map<dynamic, dynamic>;
        _chats = chatsData.entries.map((entry) {
          return ChatModel.fromJson(entry.value, entry.key);
        }).toList();

        // ترتيب الدردشات بناءً على آخر رسالة
        _chats.sort((a, b) {
          if (a.messages!.isEmpty || b.messages!.isEmpty) return 0;
          return b.messages!.last.timestamp!
              .compareTo(a.messages!.last.timestamp!); // من الأحدث إلى الأقدم
        });

        notifyListeners();
        return _chats;
      }
      return [];
    });
  }

  // دالة للحصول على Stream للرسائل
  // Stream<List<MessageModel>> getMessagesStream(String chatId) {
  //   return _databaseReference
  //       .child('chats/$chatId/messages')
  //       .onValue
  //       .map((event) {
  //     log(event.snapshot.value.toString(), name: 'event');
  //     if (event.snapshot.value != null) {
  //       Map<dynamic, dynamic> messagesData =
  //           event.snapshot.value as Map<dynamic, dynamic>;
  //       messagesData.entries.map((entry) {
  //         log(entry.value.toString());
  //         log(entry.value.toString());
  //         return ChatModel.fromJson(entry.key, entry.value);
  //       }).toList();
  //       return messagesData.entries.map((entry) {
  //         return MessageModel.fromJson(entry.value, entry.key);
  //       }).toList();
  //     }
  //     return [];
  //   });
  // }

  // دالة للحصول على Stream للرسائل
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _databaseReference
        .child('chats/$chatId/messages')
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        // تحويل Map<dynamic, dynamic> إلى Map<String, dynamic>
        Map<dynamic, dynamic> messagesData =
            event.snapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> convertedMessagesData =
            convertToMapStringDynamic(messagesData);

        // تحويل البيانات إلى List<MessageModel>
        return convertedMessagesData.entries.map((entry) {
          return MessageModel.fromJson(entry.value, entry.key);
        }).toList();
      }
      return [];
    });
  }

  // إضافة رسالة جديدة
  Future<void> addMessage(String chatId, MessageModel message) async {
    await _databaseReference
        .child('chats/$chatId/messages/${message.messageId}')
        .set(message.toJson());
  }

  // تعديل رسالة
  Future<void> updateMessage(String chatId, MessageModel message) async {
    await _databaseReference
        .child('chats/$chatId/messages/${message.messageId}')
        .update(message.toJson());
  }

  // حذف رسالة
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _databaseReference
        .child('chats/$chatId/messages/$messageId')
        .remove();
  }

  // البحث عن رسائل تحتوي على نص معين
  Future<List<MessageModel>> searchMessages(String chatId, String query) async {
    final snapshot =
        await _databaseReference.child('chats/$chatId/messages').once();
    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic> messagesData =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      return messagesData.entries
          .map((entry) {
            return MessageModel.fromJson(entry.value, entry.key);
          })
          .where((message) =>
              message.text!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return [];
  }

  Map<String, dynamic> convertToMapStringDynamic(
      Map<dynamic, dynamic> originalMap) {
    Map<String, dynamic> newMap = {};
    originalMap.forEach((key, value) {
      newMap[key.toString()] = value;
    });
    return newMap;
  }
}

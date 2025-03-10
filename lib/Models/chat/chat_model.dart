import 'package:jop_project/Models/chat/messageModel.dart';

class ChatModel {
  String? chatId; // معرف المحادثة (مثل "searcherId_companyId")
  List<MessageModel>? messages; // قائمة الرسائل في المحادثة

  ChatModel({
    this.chatId,
    this.messages,
  });

  // تحويل البيانات من JSON إلى كائن ChatModel
  ChatModel.fromJson(Map<String, dynamic> json, String chatId) {
    this.chatId = chatId;
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((key, value) {
        messages!.add(MessageModel.fromJson(value, key));
      });
      // ترتيب الرسائل حسب التاريخ والوقت
      messages!.sort((a, b) =>
          b.timestamp!.compareTo(a.timestamp!)); // من الأحدث إلى الأقدم
    }
  }

  // تحويل الكائن ChatModel إلى JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (messages != null) {
      data['messages'] = {};
      for (var message in messages!) {
        data['messages'][message.messageId] = message.toJson();
      }
    }
    return data;
  }
}

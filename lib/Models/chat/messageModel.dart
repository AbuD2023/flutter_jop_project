class MessageModel {
  String? messageId; // معرف الرسالة
  String? senderId; // معرف المرسل (مثل "searcherId" أو "companyId")
  String? text; // نص الرسالة
  DateTime? timestamp; // وقت إرسال الرسالة

  MessageModel({
    this.messageId,
    this.senderId,
    this.text,
    this.timestamp,
  });

  // تحويل البيانات من JSON إلى كائن MessageModel
  MessageModel.fromJson(Map<Object?, dynamic> json, String messageId) {
    this.messageId = messageId;
    senderId = json['senderId'];
    text = json['text'];
    timestamp = DateTime.parse(json['timestamp']); // تحويل String إلى DateTime
  }

  // تحويل الكائن MessageModel إلى JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['text'] = text;
    data['timestamp'] =
        timestamp!.toIso8601String(); // تحويل DateTime إلى String
    return data;
  }
}

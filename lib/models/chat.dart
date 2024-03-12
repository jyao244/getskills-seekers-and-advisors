class ChatData {
  final String id;
  final String avatar;
  final String uName;
  final String? message;
  final DateTime? time;
  final int unread;
  final MessageType? type;

  ChatData(
      {
      // this.avatar, this.title, this.message, this.time, this.newNum, this.type);
      required this.id,
      required this.avatar,
      required this.uName,
      this.message,
      this.time,
      this.unread = 0,
      this.type});
}

enum MessageType { SYSTEM, PUBLIC, CHAT, GROUP }

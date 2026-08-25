import 'package:cloud_firestore/cloud_firestore.dart';

class AppChatSession {
  final String id;
  final String title;
  final DateTime updatedAt;

  AppChatSession({required this.id, required this.title, required this.updatedAt});

  factory AppChatSession.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AppChatSession(
      id: doc.id,
      title: data['title'] ?? 'New Chat',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String? base64Image;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.base64Image,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      isUser: data['isUser'] ?? true,
      base64Image: data['base64Image'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'base64Image': base64Image,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
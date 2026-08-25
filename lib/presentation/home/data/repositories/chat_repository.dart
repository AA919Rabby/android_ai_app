import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AppChatSession>> getRecentSessions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AppChatSession.fromFirestore(doc)).toList());
  }

  Stream<List<ChatMessage>> getSessionMessages(String userId, String sessionId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList());
  }

  Future<void> saveMessage(String userId, String sessionId, ChatMessage message, String sessionTitle) async {
    final chatRef = _firestore.collection('users').doc(userId).collection('chats').doc(sessionId);

    await chatRef.set({
      'title': sessionTitle,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await chatRef.collection('messages').doc(message.id).set(message.toMap());
  }
}
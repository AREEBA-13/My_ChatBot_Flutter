import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bot/data/model/message_model.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Helper to get the current user's authenticated ID
  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not authenticated. Cannot access chat history.");
    }
    return user.uid;
  }

  /// Reference to the user's specific chat history collection path
  CollectionReference<Map<String, dynamic>> get _userChatRef {
    return _db.collection('users').doc(_currentUserId).collection('chat_history');
  }

  /// Saves a message to the user's isolated Firestore database subcollection
  Future<void> saveMessage(String text, bool isUser) async {
    try {
      await _userChatRef.add({
        'text': text,
        'isUser': isUser,
        'timestamp': FieldValue.serverTimestamp(), // Ensures standard unified database time
      });
    } catch (e) {
      debugPrint("Firestore Error: Failed to save message. $e");
    }
  }

  /// Stream of all messages sorted chronologically descending (newest first for reverse list)
  /// dynamically scoped to the authenticated user.
  Stream<List<MessageModel>> getMessagesStream() {
    try {
      return _userChatRef
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          final timestamp = data['timestamp'] as Timestamp?;
          return MessageModel(
            text: data['text'] ?? '',
            isUser: data['isUser'] ?? false,
            time: timestamp?.toDate() ?? DateTime.now(),
          );
        }).toList();
      });
    } catch (e) {
      debugPrint("Firestore Error: Stream failure. $e");
      return const Stream.empty();
    }
  }

  /// Clears only the current user's isolated chat history
  Future<void> clearChatHistory() async {
    try {
      final collection = await _userChatRef.get();
      final batch = _db.batch();
      for (final doc in collection.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Firestore Error: Failed to clear user history. $e");
    }
  }
}

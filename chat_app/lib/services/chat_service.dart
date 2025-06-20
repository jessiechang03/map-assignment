import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  // Send text message
  Future<void> sendMessage(String content) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final message = MessageModel(
        id: _uuid.v4(),
        senderId: user.uid,
        senderName: user.displayName ?? 'Anonymous',
        content: content,
        type: MessageType.text,
        timestamp: DateTime.now(),
      );

      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      print('Error sending message: \$e');
      throw Exception('Failed to send message');
    }
  }

  // Send image message with proper error handling
  Future<void> sendImageMessage(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Check file size (limit to 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('Image size must be less than 5MB');
      }

      // Generate unique filename
      final fileName = '\${_uuid.v4()}_\${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('chat_images').child(fileName);
      
      // Upload with metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': user.uid,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload file
      final uploadTask = ref.putFile(imageFile, metadata);
      
      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: \${(progress * 100).toStringAsFixed(2)}%');
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Create and send message
      final message = MessageModel(
        id: _uuid.v4(),
        senderId: user.uid,
        senderName: user.displayName ?? 'Anonymous',
        content: 'Photo',
        type: MessageType.image,
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
      );

      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      print('Error sending image: \$e');
      throw Exception('Failed to send image: \${e.toString()}');
    }
  }

  // Send sticker message
  Future<void> sendStickerMessage(String stickerPath) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final message = MessageModel(
        id: _uuid.v4(),
        senderId: user.uid,
        senderName: user.displayName ?? 'Anonymous',
        content: 'Sticker',
        type: MessageType.sticker,
        timestamp: DateTime.now(),
        stickerPath: stickerPath,
      );

      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      print('Error sending sticker: \$e');
      throw Exception('Failed to send sticker');
    }
  }

  // Get messages stream
  Stream<List<MessageModel>> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(100) // Limit to last 100 messages for performance
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return MessageModel.fromMap(data);
      }).toList();
    });
  }

  // Get users stream
  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Delete message (optional feature)
  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).delete();
    } catch (e) {
      print('Error deleting message: \$e');
      throw Exception('Failed to delete message');
    }
  }
}
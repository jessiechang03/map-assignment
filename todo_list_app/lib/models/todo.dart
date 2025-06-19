import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? dueDate;
  final String? imageUrl;
  final String? category;
  final int priority; // 1: Low, 2: Medium, 3: High

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.completed,
    this.createdAt,
    this.dueDate,
    this.imageUrl,
    this.category,
    this.priority = 1,
  });

  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      completed: data['completed'] ?? false,
      createdAt: data['createdAt']?.toDate(),
      dueDate: data['dueDate']?.toDate(),
      imageUrl: data['imageUrl'],
      category: data['category'],
      priority: data['priority'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'imageUrl': imageUrl,
      'category': category,
      'priority': priority,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? dueDate,
    String? imageUrl,
    String? category,
    int? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }
}
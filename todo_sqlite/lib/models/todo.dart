class Todo {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final bool completed;
  final int priority; // 1: Low, 2: Medium, 3: High
  final String? category;
  final String? imagePath;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.completed = false,
    this.priority = 1,
    this.category,
    this.imagePath,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'priority': priority,
      'category': category,
      'image_path': imagePath,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'] == 1,
      priority: map['priority'] ?? 1,
      category: map['category'],
      imagePath: map['image_path'],
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Todo copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? completed,
    int? priority,
    String? category,
    String? imagePath,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
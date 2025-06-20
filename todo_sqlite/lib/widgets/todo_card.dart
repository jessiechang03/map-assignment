import 'package:flutter/material.dart';
import 'dart:io';
import '../models/todo.dart';
import '../services/database_helper.dart';
import '../services/image_service.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTodoUpdated;

  const TodoCard({
    Key? key,
    required this.todo,
    required this.onTodoUpdated,
  }) : super(key: key);

  Future<void> _toggleTodo() async {
    await DatabaseHelper.instance.toggleTodoComplete(todo.id!, !todo.completed);
    onTodoUpdated();
  }

  Future<void> _deleteTodo(BuildContext context) async {
    // Delete associated image if exists
    if (todo.imagePath != null) {
      await ImageService.instance.deleteImage(todo.imagePath!);
    }
    
    await DatabaseHelper.instance.deleteTodo(todo.id!);
    onTodoUpdated();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todo deleted')),
    );
  }

  Color _getPriorityColor() {
    switch (todo.priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getPriorityText() {
    switch (todo.priority) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: () => _showTodoDetails(context),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: todo.completed,
                    onChanged: (value) => _toggleTodo(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: todo.completed ? Colors.grey : Colors.black,
                          ),
                        ),
                        if (todo.description != null && todo.description!.isNotEmpty)
                          Text(
                            todo.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getPriorityColor()),
                    ),
                    child: Text(
                      _getPriorityText(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPriorityColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTodo(context),
                  ),
                ],
              ),
              if (todo.imagePath != null && ImageService.instance.imageExists(todo.imagePath!))
                Container(
                  margin: EdgeInsets.only(top: 8),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(todo.imagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (todo.category != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      todo.category!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              if (todo.dueDate != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Due: ${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTodoDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(todo.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description != null && todo.description!.isNotEmpty) ...[
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(todo.description!),
                SizedBox(height: 16),
              ],
              if (todo.imagePath != null && ImageService.instance.imageExists(todo.imagePath!)) ...[
                Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(todo.imagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
              if (todo.category != null) ...[
                Text('Category: ${todo.category!}', style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
              ],
              Text('Priority: ${_getPriorityText()}', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              if (todo.dueDate != null) ...[
                Text('Due Date: ${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}', 
                     style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
              ],
              Text('Status: ${todo.completed ? "Completed" : "Pending"}', 
                   style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
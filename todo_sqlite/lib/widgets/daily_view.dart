import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_card.dart';

class DailyView extends StatefulWidget {
  final List<Todo> todos;
  final VoidCallback onTodoUpdated;

  const DailyView({
    Key? key,
    required this.todos,
    required this.onTodoUpdated,
  }) : super(key: key);

  @override
  _DailyViewState createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  DateTime _selectedDate = DateTime.now();
  PageController _pageController = PageController(initialPage: 365);

  List<Todo> _getTodosForDate(DateTime date) {
    return widget.todos.where((todo) {
      if (todo.dueDate == null) return false;
      return todo.dueDate!.year == date.year &&
             todo.dueDate!.month == date.month &&
             todo.dueDate!.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedDate = DateTime.now().add(Duration(days: index - 365));
              });
            },
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index - 365));
              final isSelected = date.day == _selectedDate.day &&
                                date.month == _selectedDate.month &&
                                date.year == _selectedDate.year;
              final todosCount = _getTodosForDate(date).length;

              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      _getMonthName(date.month),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    if (todosCount > 0)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$todosCount',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.blue : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: _buildTodosForSelectedDay(),
        ),
      ],
    );
  }

  Widget _buildTodosForSelectedDay() {
    final todos = _getTodosForDate(_selectedDate);
    
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No todos for today',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Tap + to add a new todo',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoCard(
          todo: todos[index],
          onTodoUpdated: widget.onTodoUpdated,
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
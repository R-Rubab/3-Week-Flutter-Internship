
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(task.title + task.time),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),

      ///  BACKGROUND
      background: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.redAccent, Colors.red]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        /// 💎 GLASS EFFECT
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),

              child: Row(
                children: [
                  /// ✅ CHECKBOX
                  Checkbox(value: task.isDone, onChanged: (_) => onToggle()),

                  SizedBox(width: 8),

                  /// 📋 TEXT CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration:
                                task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),

                        SizedBox(height: 4),

                        /// STATUS
                        Text(
                          task.isDone ? "Completed" : "Pending",
                          style: TextStyle(
                            color: task.isDone ? Colors.green : Colors.orange,
                            fontSize: 12,
                          ),
                        ),

                        SizedBox(height: 4),

                        /// DATE + TIME
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12),
                            SizedBox(width: 4),
                            Text(task.date, style: theme.textTheme.bodySmall),
                            SizedBox(width: 10),
                            Icon(Icons.access_time, size: 12),
                            SizedBox(width: 4),
                            Text(task.time, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///  ACTION BUTTONS
                  Row(
                    children: [
                      _circleButton(
                        icon: Icons.edit,
                        color: Colors.blue,
                        onTap: onEdit,
                      ),
                      SizedBox(width: 8),
                      _circleButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///  REUSABLE BUTTON
  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: color.withValues(alpha: 0.9),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}

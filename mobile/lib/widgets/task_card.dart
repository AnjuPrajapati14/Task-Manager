import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'custom_button.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(TaskStatus)? onStatusChanged;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = UIHelper.getStatusColor(task.status);
    final isOverdue = task.isOverdue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue
            ? const BorderSide(color: Color(AppColors.error), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(AppColors.gray900),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        CustomIconButton(
                          icon: Icons.edit_outlined,
                          onPressed: onEdit,
                          color: const Color(AppColors.gray500),
                          size: 20,
                          tooltip: 'Edit task',
                        ),
                      if (onDelete != null)
                        CustomIconButton(
                          icon: Icons.delete_outline,
                          onPressed: onDelete,
                          color: const Color(AppColors.error),
                          size: 20,
                          tooltip: 'Delete task',
                        ),
                    ],
                  ),
                ],
              ),
              
              // Description
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppColors.gray600),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Status and deadline row
              Row(
                children: [
                  // Status dropdown
                  Expanded(
                    child: DropdownButtonFormField<TaskStatus>(
                      initialValue: task.status,
                      onChanged: (status) {
                        if (status != null && onStatusChanged != null) {
                         onStatusChanged!(status);
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: statusColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: statusColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: statusColor, width: 2),
                        ),
                        fillColor: statusColor.withOpacity(0.1),
                        filled: true,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: statusColor,
                        size: 16,
                      ),
                      items: TaskStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: UIHelper.getStatusColor(status),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Overdue indicator
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.error).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(AppColors.error),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        AppStrings.overdue,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(AppColors.error),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Footer with deadline and created date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Deadline
                  if (task.deadline != null)
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: isOverdue 
                              ? const Color(AppColors.error)
                              : const Color(AppColors.gray500),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateHelper.formatDate(task.deadline!),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue 
                                ? const Color(AppColors.error)
                                : const Color(AppColors.gray500),
                            fontWeight: isOverdue ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),

                  // Created date
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(AppColors.gray400),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateHelper.formatRelativeTime(task.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(AppColors.gray400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TaskStatus _selectedStatus = TaskStatus.pending;
  DateTime? _selectedDeadline;
  bool _isLoading = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    
    if (isEditing) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _selectedStatus = task.status;
      _selectedDeadline = task.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();
    final initialDate = _selectedDeadline ?? now.add(const Duration(days: 1));
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? initialDate : now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      
      if (time != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _clearDeadline() {
    setState(() {
      _selectedDeadline = null;
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    UIHelper.hideKeyboard(context);

    try {
      final task = Task(
        id: isEditing ? widget.task!.id : '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        status: _selectedStatus,
        deadline: _selectedDeadline,
        userId: isEditing ? widget.task!.userId : '',
        createdAt: isEditing ? widget.task!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final taskProvider = context.read<TaskProvider>();
      String? error;

      if (isEditing) {
        error = await taskProvider.updateTask(widget.task!.id, task);
      } else {
        error = await taskProvider.createTask(task);
      }

      if (mounted) {
        if (error == null) {
          Navigator.of(context).pop();
          UIHelper.showToast(
            isEditing ? 'Task updated successfully' : 'Task created successfully',
          );
        } else {
          UIHelper.showSnackBar(context, error, isError: true);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? AppStrings.editTask : AppStrings.createTask,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(AppColors.primary),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              CustomTextField(
                label: AppStrings.taskTitle,
                hint: 'Enter task title',
                controller: _titleController,
                validator: ValidationHelper.validateTaskTitle,
                maxLength: 100,
              ),
              
              const SizedBox(height: 20),
              
              // Description Field
              CustomTextField(
                label: AppStrings.taskDescription,
                hint: 'Enter task description (optional)',
                controller: _descriptionController,
                validator: ValidationHelper.validateTaskDescription,
                maxLines: 4,
                maxLength: 500,
                keyboardType: TextInputType.multiline,
              ),
              
              const SizedBox(height: 20),
              
              // Status Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.taskStatus,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(AppColors.gray700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<TaskStatus>(
                    value: _selectedStatus,
                    onChanged: (status) {
                      if (status != null) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(AppColors.gray300),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(AppColors.gray300),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(AppColors.primary),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: TaskStatus.values.map((status) {
                      final color = UIHelper.getStatusColor(status);
                      return DropdownMenuItem(
                        value: status,
                        child: Row(
                          children: [
                            Icon(
                              UIHelper.getStatusIcon(status),
                              color: color,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status.name.toUpperCase(),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Deadline Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.taskDeadline,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(AppColors.gray700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _selectDeadline,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(AppColors.gray300),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(AppColors.gray400),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDeadline != null
                                  ? DateHelper.formatDateTime(_selectedDeadline!)
                                  : 'Select deadline (optional)',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedDeadline != null
                                    ? const Color(AppColors.gray900)
                                    : const Color(AppColors.gray400),
                              ),
                            ),
                          ),
                          if (_selectedDeadline != null)
                            IconButton(
                              onPressed: _clearDeadline,
                              icon: const Icon(
                                Icons.clear,
                                color: Color(AppColors.gray400),
                                size: 20,
                              ),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.cancel,
                      onPressed: _isLoading ? null : () {
                        Navigator.of(context).pop();
                      },
                      variant: ButtonVariant.outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: isEditing ? AppStrings.update : AppStrings.save,
                      onPressed: _isLoading ? null : _handleSave,
                      isLoading: _isLoading,
                    ),
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
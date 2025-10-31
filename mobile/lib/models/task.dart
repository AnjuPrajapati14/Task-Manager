enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime? deadline;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.deadline,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: _statusFromString(json['status'] ?? 'pending'),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      userId: json['user'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'status': _statusToString(status),
      'deadline': deadline?.toIso8601String(),
      'user': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'status': _statusToString(status),
      'deadline': deadline?.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    if (description != null) data['description'] = description;
    data['status'] = _statusToString(status);
    if (deadline != null) data['deadline'] = deadline!.toIso8601String();
    return data;
  }

  static TaskStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return TaskStatus.pending;
      case 'in-progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      default:
        return TaskStatus.pending;
    }
  }

  static String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'in-progress';
      case TaskStatus.completed:
        return 'completed';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  bool get isOverdue {
    if (deadline == null || status == TaskStatus.completed) return false;
    return deadline!.isBefore(DateTime.now());
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? deadline,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, status: $status}';
  }
}
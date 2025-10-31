// Import so this file can use them
import 'user.dart';
import 'task.dart';

// Export so other files that import this one
// also get access to User and Task automatically
export 'user.dart';
export 'task.dart';

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error'],
    );
  }

  factory ApiResponse.success(T data, [String? message]) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(
      success: false,
      error: error,
    );
  }
}

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }
}

class TasksResponse {
  final List<Task> tasks;
  final TaskPagination? pagination;

  TasksResponse({
    required this.tasks,
    this.pagination,
  });

  factory TasksResponse.fromJson(Map<String, dynamic> json) {
    return TasksResponse(
      tasks: (json['tasks'] as List?)
          ?.map((taskJson) => Task.fromJson(taskJson))
          .toList() ?? [],
      pagination: json['pagination'] != null
          ? TaskPagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class TaskPagination {
  final int currentPage;
  final int totalPages;
  final int totalTasks;
  final bool hasNextPage;
  final bool hasPrevPage;

  TaskPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalTasks,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory TaskPagination.fromJson(Map<String, dynamic> json) {
    return TaskPagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalTasks: json['totalTasks'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}

class TaskStats {
  final int pending;
  final int inProgress;
  final int completed;

  TaskStats({
    required this.pending,
    required this.inProgress,
    required this.completed,
  });

  factory TaskStats.fromJson(Map<String, dynamic> json) {
    return TaskStats(
      pending: json['pending'] ?? 0,
      inProgress: json['in-progress'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }

  int get total => pending + inProgress + completed;
}


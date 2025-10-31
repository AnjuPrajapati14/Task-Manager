import 'package:flutter/material.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Task> _tasks = [];
  TaskStats? _stats;
  bool _isLoading = false;
  String? _error;
  TaskPagination? _pagination;
  
  // Filter and sort options
  String? _statusFilter;
  int _currentPage = 1;
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';
  
  // Getters
  List<Task> get tasks => _tasks;
  TaskStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskPagination? get pagination => _pagination;
  String? get statusFilter => _statusFilter;
  int get currentPage => _currentPage;
  String get sortBy => _sortBy;
  String get sortOrder => _sortOrder;

  // Load tasks with current filters
  Future<void> loadTasks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _apiService.getTasks(
        status: _statusFilter,
        page: _currentPage,
        limit: 10,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      );
      
      if (response.success && response.data != null) {
        if (refresh || _currentPage == 1) {
          _tasks = response.data!.tasks;
        } else {
          // Append for pagination
          _tasks.addAll(response.data!.tasks);
        }
        _pagination = response.data!.pagination;
      } else {
        _setError(response.error ?? 'Failed to load tasks');
      }
    } catch (e) {
      _setError('An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  // Load task statistics
  Future<void> loadStats() async {
    try {
      final response = await _apiService.getTaskStats();
      
      if (response.success && response.data != null) {
        _stats = response.data;
        notifyListeners();
      }
    } catch (e) {
      // Stats loading error is not critical, don't show error
      debugPrint('Failed to load stats: $e');
    }
  }

  // Create a new task
  Future<String?> createTask(Task task) async {
    try {
      final response = await _apiService.createTask(task);
      
      if (response.success && response.data != null) {
        // Add the new task to the beginning of the list
        _tasks.insert(0, response.data!);
        notifyListeners();
        
        // Refresh stats
        loadStats();
        
        return null; // Success
      } else {
        return response.error ?? 'Failed to create task';
      }
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Update an existing task
  Future<String?> updateTask(String taskId, Task updatedTask) async {
    try {
      final response = await _apiService.updateTask(taskId, updatedTask);
      
      if (response.success && response.data != null) {
        // Update the task in the list
        final index = _tasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          _tasks[index] = response.data!;
          notifyListeners();
        }
        
        // Refresh stats
        loadStats();
        
        return null; // Success
      } else {
        return response.error ?? 'Failed to update task';
      }
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Delete a task
  Future<String?> deleteTask(String taskId) async {
    try {
      final response = await _apiService.deleteTask(taskId);
      
      if (response.success) {
        // Remove the task from the list
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
        
        // Refresh stats
        loadStats();
        
        return null; // Success
      } else {
        return response.error ?? 'Failed to delete task';
      }
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Update task status quickly
  Future<String?> updateTaskStatus(String taskId, TaskStatus status) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return 'Task not found';
    
    final originalTask = _tasks[taskIndex];
    final updatedTask = originalTask.copyWith(status: status);
    
    // Optimistically update UI
    _tasks[taskIndex] = updatedTask;
    notifyListeners();
    
    // Make API call
    final error = await updateTask(taskId, updatedTask);
    
    if (error != null) {
      // Revert on error
      _tasks[taskIndex] = originalTask;
      notifyListeners();
    }
    
    return error;
  }

  // Set status filter
  void setStatusFilter(String? status) {
    if (_statusFilter != status) {
      _statusFilter = status;
      _currentPage = 1;
      loadTasks(refresh: true);
    }
  }

  // Set sort options
  void setSortOptions(String sortBy, String sortOrder) {
    if (_sortBy != sortBy || _sortOrder != sortOrder) {
      _sortBy = sortBy;
      _sortOrder = sortOrder;
      _currentPage = 1;
      loadTasks(refresh: true);
    }
  }

  // Load next page
  Future<void> loadNextPage() async {
    if (_pagination != null && _pagination!.hasNextPage && !_isLoading) {
      _currentPage++;
      await loadTasks();
    }
  }

  // Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadTasks(refresh: true),
      loadStats(),
    ]);
  }

  // Get task by ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all data
  void clear() {
    _tasks = [];
    _stats = null;
    _pagination = null;
    _currentPage = 1;
    _statusFilter = null;
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
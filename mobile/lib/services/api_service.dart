import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _token;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Request interceptor to add auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, clear storage
          await clearAuthData();
        }
        handler.next(error);
      },
    ));

    // Load token from storage
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearAuthData() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  bool get isAuthenticated => _token != null;

  // Auth endpoints
  Future<ApiResponse<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        await saveToken(authResponse.token);
        await _saveUserData(authResponse.user);
        return ApiResponse.success(authResponse, response.data['message']);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<AuthResponse>> signup(
      String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/signup', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        await saveToken(authResponse.token);
        await _saveUserData(authResponse.user);
        return ApiResponse.success(authResponse, response.data['message']);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Signup failed');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');

      if (response.data['success']) {
        final user = User.fromJson(response.data['data']['user']);
        await _saveUserData(user);
        return ApiResponse.success(user);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Task endpoints
  Future<ApiResponse<TasksResponse>> getTasks({
    String? status,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dio.get('/tasks', queryParameters: queryParams);

      if (response.data['success']) {
        final tasksResponse = TasksResponse.fromJson(response.data['data']);
        return ApiResponse.success(tasksResponse);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to get tasks');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<Task>> createTask(Task task) async {
    try {
      final response = await _dio.post('/tasks', data: task.toCreateJson());

      if (response.data['success']) {
        final createdTask = Task.fromJson(response.data['data']['task']);
        return ApiResponse.success(createdTask, response.data['message']);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to create task');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<Task>> updateTask(String taskId, Task task) async {
    try {
      final response = await _dio.put('/tasks/$taskId', data: task.toUpdateJson());

      if (response.data['success']) {
        final updatedTask = Task.fromJson(response.data['data']['task']);
        return ApiResponse.success(updatedTask, response.data['message']);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to update task');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<void>> deleteTask(String taskId) async {
    try {
      final response = await _dio.delete('/tasks/$taskId');

      if (response.data['success']) {
        return ApiResponse.success(null, response.data['message']);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to delete task');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<ApiResponse<TaskStats>> getTaskStats() async {
    try {
      final response = await _dio.get('/tasks/stats');

      if (response.data['success']) {
        final stats = TaskStats.fromJson(response.data['data']['stats']);
        return ApiResponse.success(stats);
      } else {
        return ApiResponse.error(response.data['message'] ?? 'Failed to get task stats');
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        if (e.response?.data != null && e.response?.data['message'] != null) {
          return e.response!.data['message'];
        }
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return 'No internet connection';
        }
        return 'An unexpected error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }
}
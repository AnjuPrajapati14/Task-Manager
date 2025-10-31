class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // iOS simulator
  // static const String baseUrl = 'https://your-api-domain.com/api'; // Production
}

class AppConstants {
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';
  
  // Shared Preferences Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserData = 'user_data';
  static const String keyThemeMode = 'theme_mode';
  
  // API Timeouts
  static const int connectTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 10;
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
}

class AppColors {
  // Primary colors
  static const primary = 0xFF2563EB;
  static const primaryLight = 0xFF3B82F6;
  static const primaryDark = 0xFF1D4ED8;
  
  // Status colors
  static const pending = 0xFFF59E0B;
  static const inProgress = 0xFF3B82F6;
  static const completed = 0xFF10B981;
  
  // Semantic colors
  static const success = 0xFF10B981;
  static const error = 0xFFEF4444;
  static const warning = 0xFFF59E0B;
  static const info = 0xFF3B82F6;
  
  // Neutral colors
  static const gray50 = 0xFFF9FAFB;
  static const gray100 = 0xFFF3F4F6;
  static const gray200 = 0xFFE5E7EB;
  static const gray300 = 0xFFD1D5DB;
  static const gray400 = 0xFF9CA3AF;
  static const gray500 = 0xFF6B7280;
  static const gray600 = 0xFF4B5563;
  static const gray700 = 0xFF374151;
  static const gray800 = 0xFF1F2937;
  static const gray900 = 0xFF111827;
}

class AppStrings {
  // App
  static const String appTitle = 'Task Manager';
  static const String taskManagement = 'Task Management';
  
  // Auth
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String name = 'Name';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signInToAccount = 'Sign in to your account';
  static const String createAccount = 'Create your account';
  
  // Tasks
  static const String tasks = 'Tasks';
  static const String myTasks = 'My Tasks';
  static const String addTask = 'Add Task';
  static const String createTask = 'Create Task';
  static const String editTask = 'Edit Task';
  static const String deleteTask = 'Delete Task';
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Description';
  static const String taskStatus = 'Status';
  static const String taskDeadline = 'Deadline';
  static const String noTasks = 'No tasks found';
  static const String noTasksMessage = 'Get started by creating your first task';
  
  // Status
  static const String pending = 'Pending';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String overdue = 'Overdue';
  
  // Actions
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String update = 'Update';
  static const String refresh = 'Refresh';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String search = 'Search';
  
  // Messages
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String noInternetConnection = 'No internet connection';
  static const String somethingWentWrong = 'Something went wrong';
  static const String tryAgain = 'Try Again';
  static const String confirmDeleteTask = 'Are you sure you want to delete this task?';
  
  // Validation
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String nameTooShort = 'Name must be at least 2 characters';
}
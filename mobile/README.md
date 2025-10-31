# Task Management Mobile App

A Flutter mobile application for task management with backend integration, built with Material Design and Provider state management.

## 🚀 Features

- **Modern UI/UX** - Material Design with custom components
- **Cross-Platform** - Runs on both iOS and Android
- **Authentication** - JWT-based login/signup with persistent sessions
- **Task Management** - Complete CRUD operations with real-time updates
- **Status Tracking** - Pending, In Progress, and Completed task states
- **Advanced Filtering** - Filter tasks by status with tabs
- **Deadline Management** - Set and track task deadlines with overdue indicators
- **Statistics Dashboard** - Visual task statistics overview
- **Offline Handling** - Graceful handling of network issues
- **Loading States** - Smooth loading experiences with shimmer effects
- **Pull-to-Refresh** - Refresh data with pull gesture
- **Infinite Scroll** - Efficient pagination for large task lists

## 📁 Project Structure

```
mobile/
├── lib/
│   ├── models/                   # Data models
│   │   ├── user.dart            # User model
│   │   ├── task.dart            # Task model with enums
│   │   └── api_response.dart    # API response models
│   ├── services/
│   │   └── api_service.dart     # HTTP client and API calls
│   ├── providers/               # State management
│   │   ├── auth_provider.dart   # Authentication state
│   │   └── task_provider.dart   # Task management state
│   ├── screens/                 # App screens
│   │   ├── login_screen.dart    # User login
│   │   ├── signup_screen.dart   # User registration
│   │   ├── home_screen.dart     # Main dashboard with task list
│   │   └── task_form_screen.dart # Create/edit task form
│   ├── widgets/                 # Reusable UI components
│   │   ├── custom_text_field.dart # Custom input field
│   │   ├── custom_button.dart   # Custom button components
│   │   ├── task_card.dart       # Individual task display
│   │   ├── loading_widget.dart  # Loading states and shimmer
│   │   └── empty_state.dart     # Empty and error states
│   ├── utils/                   # Utilities and helpers
│   │   ├── constants.dart       # App constants and colors
│   │   └── helpers.dart         # Helper functions and validators
│   └── main.dart               # App entry point
├── android/                    # Android-specific configuration
├── ios/                        # iOS-specific configuration
├── pubspec.yaml               # Dependencies and assets
└── README.md                  # This file
```

## 🛠 Installation & Setup

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for device testing
- Backend API running (see backend README)

### Steps

1. **Navigate to mobile directory**
   ```bash
   cd mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   
   Edit `lib/utils/constants.dart`:
   ```dart
   class ApiConstants {
     // For Android emulator
     static const String baseUrl = 'http://10.0.2.2:5000/api';
     
     // For iOS simulator
     // static const String baseUrl = 'http://localhost:5000/api';
     
     // For physical device (replace with your computer's IP)
     // static const String baseUrl = 'http://192.168.1.100:5000/api';
     
     // For production
     // static const String baseUrl = 'https://your-api-domain.com/api';
   }
   ```

4. **Run the app**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   
   # Specific device
   flutter run -d <device-id>
   ```

5. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   
   # iOS (macOS only)
   flutter build ios --release
   ```

## 📱 App Screens

### Authentication Flow
- **Login Screen** - Email/password authentication with demo credentials
- **Signup Screen** - User registration with validation

### Main App
- **Home Screen** - Task dashboard with statistics and filtered lists
- **Task Form Screen** - Create/edit task with deadline picker

## 🔐 Authentication

### JWT Token Management
- Secure token storage using SharedPreferences
- Automatic token attachment to API requests
- Token validation and refresh handling
- Automatic logout on token expiration

### User Session
- Persistent login across app restarts
- Profile data caching
- Secure logout with data cleanup

## 📊 State Management

### Provider Pattern
- **AuthProvider** - Manages user authentication state
- **TaskProvider** - Handles task operations and filtering

### Features
- Real-time UI updates
- Optimistic updates for better UX
- Error handling and recovery
- Loading states management

## 🎨 UI Components

### Custom Widgets
- **CustomTextField** - Styled input fields with validation
- **CustomButton** - Multiple button variants with loading states
- **TaskCard** - Rich task display with actions
- **LoadingWidget** - Animated loading indicators

### Material Design
- Consistent color scheme
- Material 3 design system
- Custom theme configuration
- Responsive layouts

## 🔧 Key Features

### Task Management
- **Create Tasks** - Title, description, status, and deadline
- **Edit Tasks** - In-place editing with form validation
- **Delete Tasks** - Confirmation dialogs
- **Status Updates** - Quick status changes with dropdowns
- **Deadline Tracking** - Visual overdue indicators

### Filtering & Navigation
- **Tab-based Filtering** - All, Pending, In Progress, Completed
- **Pull-to-Refresh** - Refresh data with gesture
- **Infinite Scroll** - Load more tasks automatically
- **Search & Sort** - Backend-powered filtering

### User Experience
- **Shimmer Loading** - Skeleton screens during load
- **Error Handling** - User-friendly error messages
- **Offline Support** - Graceful network error handling
- **Toast Notifications** - Success/error feedback

## 📱 Device Support

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest
- Permissions: Internet, Network State

### iOS
- Minimum version: iOS 11.0
- Supports iPhone and iPad
- Portrait orientation optimized

## 🌐 API Integration

### Endpoints Used
- `POST /api/auth/login` - User authentication
- `POST /api/auth/signup` - User registration
- `GET /api/auth/profile` - Get user profile
- `GET /api/tasks` - Get tasks with filtering/pagination
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task
- `GET /api/tasks/stats` - Get task statistics

### Error Handling
- Network connectivity issues
- Server errors with user-friendly messages
- Token expiration handling
- Input validation errors

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### Test Coverage
```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Deployment

### Android Release
```bash
# Generate keystore (first time only)
keytool -genkey -v -keystore android/app/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

### iOS Release
```bash
# Build for iOS (macOS only)
flutter build ios --release

# Archive in Xcode for App Store
open ios/Runner.xcworkspace
```

### Configuration for Production
1. Update API base URL in constants
2. Configure app signing certificates
3. Update app version and build number
4. Test on physical devices
5. Submit to app stores

## 📋 Dependencies

### Core Dependencies
- `flutter` - Flutter SDK
- `provider` - State management
- `dio` - HTTP client
- `shared_preferences` - Local storage

### UI Dependencies
- `material_design_icons_flutter` - Additional icons
- `flutter_spinkit` - Loading animations
- `fluttertoast` - Toast notifications

### Utility Dependencies
- `intl` - Date formatting
- `email_validator` - Email validation
- `connectivity_plus` - Network connectivity

## 🔧 Development Tips

### Debugging
- Use Flutter Inspector for UI debugging
- Check device logs: `flutter logs`
- Use breakpoints in VS Code/Android Studio
- Test on multiple screen sizes

### Performance
- Use `const` constructors where possible
- Implement proper widget lifecycle management
- Optimize image assets
- Monitor memory usage

### Code Quality
- Follow Dart style guide
- Use meaningful variable names
- Add proper documentation
- Implement error handling

## 📄 License

MIT License - feel free to use this project for learning and development.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on both platforms
5. Submit a pull request

## 📞 Support

For issues and questions:
1. Check Flutter documentation
2. Verify backend API is running
3. Check device logs for errors
4. Test network connectivity
5. Review API endpoint configuration

## 🔗 Related Projects

- [Backend API](../backend/README.md) - Node.js + Express + MongoDB
- [Frontend Web App](../frontend/README.md) - React + Next.js + Tailwind
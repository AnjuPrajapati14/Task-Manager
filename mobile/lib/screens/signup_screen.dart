import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    UIHelper.hideKeyboard(context);

    final authProvider = context.read<AuthProvider>();
    final error = await authProvider.signup(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (error == null) {
      // Signup successful, navigate to home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      UIHelper.showToast('Account created successfully!');
    } else {
      // Show error
      UIHelper.showSnackBar(context, error, isError: true);
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // App Icon
                const Icon(
                  Icons.check_box,
                  size: 80,
                  color: Color(AppColors.primary),
                ),
                
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  AppStrings.createAccount,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.gray900),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyHaveAccount,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(AppColors.gray600),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateBack,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        AppStrings.login,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Name Field
                CustomTextField(
                  label: AppStrings.name,
                  hint: 'Enter your full name',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: ValidationHelper.validateName,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(AppColors.gray400),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Email Field
                CustomTextField(
                  label: AppStrings.email,
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationHelper.validateEmail,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(AppColors.gray400),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Password Field
                CustomTextField(
                  label: AppStrings.password,
                  hint: 'Create a password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: ValidationHelper.validatePassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color(AppColors.gray400),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Password hint
                const Text(
                  'Password must be at least 6 characters long',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(AppColors.gray500),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Signup Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: AppStrings.createAccount,
                      onPressed: authProvider.isLoading ? null : _handleSignup,
                      isLoading: authProvider.isLoading,
                      width: double.infinity,
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Terms text
                const Text(
                  'By creating an account, you agree to our Terms of Service and Privacy Policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(AppColors.gray500),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
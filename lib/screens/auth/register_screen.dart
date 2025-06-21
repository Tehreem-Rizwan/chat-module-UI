// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../config/theme.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/common/custom_button.dart';
// import '../../widgets/common/custom_text_field.dart';
// import '../../utils/validators.dart';
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   bool _agreeToTerms = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _register() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (!_agreeToTerms) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please agree to the Terms of Service and Privacy Policy'),
//             backgroundColor: AppTheme.error,
//           ),
//         );
//         return;
//       }

//       // Hide keyboard
//       FocusScope.of(context).unfocus();

//       final authProvider = Provider.of<AuthProvider>(context, listen: false);

//       // For demo purposes, always show success
//       final bool success = true; // Mocking successful registration
//       if (success) {
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Registration successful! Please check your email to verify your account.'),
//             backgroundColor: AppTheme.success,
//           ),
//         );

//         // Navigate back to login
//         Future.delayed(const Duration(seconds: 2), () {
//           Navigator.of(context).pop();
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: Theme.of(context).textTheme.bodyLarge?.color,
//         ),
//         title: const Text(
//           'Create Account',
//           style: TextStyle(
//             color: AppTheme.textLightPrimary,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Registration form
//                 CustomTextField(
//                   controller: _emailController,
//                   labelText: 'Email',
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: Validators.validateEmail,
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   controller: _usernameController,
//                   labelText: 'Username',
//                   prefixIcon: const Icon(Icons.person_outline),
//                   validator: Validators.validateUsername,
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock_outline),
//                   obscureText: !_isPasswordVisible,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                   validator: Validators.validatePassword,
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   controller: _confirmPasswordController,
//                   labelText: 'Confirm Password',
//                   prefixIcon: const Icon(Icons.lock_outline),
//                   obscureText: !_isConfirmPasswordVisible,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isConfirmPasswordVisible
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//                       });
//                     },
//                   ),
//                   validator: (value) => Validators.validateConfirmPassword(
//                     value,
//                     _passwordController.text,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Terms of service checkbox
//                 Row(
//                   children: [
//                     Theme(
//                       data: ThemeData(
//                         unselectedWidgetColor: AppTheme.textLightSecondary,
//                       ),
//                       child: Checkbox(
//                         value: _agreeToTerms,
//                         activeColor: AppTheme.primaryColor,
//                         onChanged: (value) {
//                           setState(() {
//                             _agreeToTerms = value ?? false;
//                           });
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         'I agree to the Terms of Service and Privacy Policy',
//                         style: TextStyle(
//                           color: Theme.of(context).textTheme.bodySmall?.color,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 32),
//                 // Register button
//                 CustomButton(
//                   text: 'Register',
//                   isLoading: authProvider.isLoading,
//                   onPressed: _register,
//                 ),
//                 if (authProvider.error != null) ...[
//                   const SizedBox(height: 16),
//                   Text(
//                     authProvider.error!,
//                     style: const TextStyle(
//                       color: AppTheme.error,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//                 const SizedBox(height: 24),
//                 // Login option
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have an account?',
//                       style: TextStyle(
//                         color: Theme.of(context).textTheme.bodySmall?.color,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Login'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../utils/validators.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Please agree to the Terms of Service and Privacy Policy'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      FocusScope.of(context).unfocus();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final bool success = true; // Mock registration
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please check your email.'),
            backgroundColor: AppTheme.success,
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithGoogle();
    if (authProvider.user != null) {
      Navigator.pop(context); // Go back or to home screen if needed
    }
  }

  Future<void> _handleFacebookSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithFacebook();
    if (authProvider.user != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: AppTheme.textLightPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: Validators.validateUsername,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor: AppTheme.textLightSecondary,
                      ),
                      child: Checkbox(
                        value: _agreeToTerms,
                        activeColor: AppTheme.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Register',
                  isLoading: authProvider.isLoading,
                  onPressed: _register,
                ),
                if (authProvider.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    authProvider.error!,
                    style: const TextStyle(
                      color: AppTheme.error,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                const Center(child: Text("OR", style: TextStyle(fontSize: 16))),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Image.asset('assets/images/google.png', height: 20),
                    label: const Text('Continue with Google'),
                    onPressed: _handleGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Image.asset('assets/images/facebook.png', height: 20),
                    label: const Text('Continue with Facebook'),
                    onPressed: _handleFacebookSignIn,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF1877F2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

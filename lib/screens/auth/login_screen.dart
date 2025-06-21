// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:wasupmate/utils/constants.dart';

// // import '../../config/theme.dart';
// // import '../../providers/auth_provider.dart';
// // import '../../providers/event_provider.dart';
// // import '../../widgets/common/custom_button.dart';
// // import '../../widgets/common/custom_text_field.dart';
// // import '../../utils/validators.dart';
// // import '../home/home_screen.dart';
// // import 'register_screen.dart';
// // import 'forgot_password_screen.dart';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({Key? key}) : super(key: key);

// //   @override
// //   _LoginScreenState createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   bool _isPasswordVisible = false;
// //   bool _rememberMe = false;

// //   @override
// //   void dispose() {
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _login() async {
// //     if (_formKey.currentState?.validate() ?? false) {
// //       // Hide keyboard
// //       FocusScope.of(context).unfocus();

// //       final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //       final eventProvider = Provider.of<EventProvider>(context, listen: false);

// //       // For demo purposes, allow any login
// //       final bool success = true; // Mocking successful login
// //       if (success) {
// //         // Load mock events for demo
// //         eventProvider.setMockEvents();

// //         // Navigate to home screen
// //         Navigator.of(context).pushReplacement(
// //           PageRouteBuilder(
// //             pageBuilder: (context, animation, secondaryAnimation) =>
// //                 const HomeScreen(),
// //             transitionsBuilder:
// //                 (context, animation, secondaryAnimation, child) {
// //               const begin = Offset(1.0, 0.0);
// //               const end = Offset.zero;
// //               const curve = Curves.easeOut;

// //               var tween =
// //                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
// //               var offsetAnimation = animation.drive(tween);

// //               return SlideTransition(position: offsetAnimation, child: child);
// //             },
// //             transitionDuration: const Duration(milliseconds: 500),
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final authProvider = Provider.of<AuthProvider>(context);
// //     final size = MediaQuery.of(context).size;

// //     return Scaffold(
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
// //           child: SizedBox(
// //             height: size.height -
// //                 MediaQuery.of(context).padding.top -
// //                 MediaQuery.of(context).padding.bottom,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 const SizedBox(height: 48),
// //                 // Logo and branding
// //                 _buildHeader(),
// //                 const SizedBox(height: 40),
// //                 // Login form
// //                 Form(
// //                   key: _formKey,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// //                     children: [
// //                       CustomTextField(
// //                         controller: _emailController,
// //                         labelText: 'Email',
// //                         prefixIcon: const Icon(Icons.email_outlined),
// //                         keyboardType: TextInputType.emailAddress,
// //                         validator: Validators.validateEmail,
// //                       ),
// //                       const SizedBox(height: 20),
// //                       CustomTextField(
// //                         controller: _passwordController,
// //                         labelText: 'Password',
// //                         prefixIcon: const Icon(Icons.lock_outline),
// //                         obscureText: !_isPasswordVisible,
// //                         suffixIcon: IconButton(
// //                           icon: Icon(
// //                             _isPasswordVisible
// //                                 ? Icons.visibility_off_outlined
// //                                 : Icons.visibility_outlined,
// //                           ),
// //                           onPressed: () {
// //                             setState(() {
// //                               _isPasswordVisible = !_isPasswordVisible;
// //                             });
// //                           },
// //                         ),
// //                         validator: Validators.validatePassword,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       // Remember me and forgot password
// //                       _buildRememberForgot(),
// //                       const SizedBox(height: 24),
// //                       // Login button
// //                       CustomButton(
// //                         text: 'Login',
// //                         isLoading: authProvider.isLoading,
// //                         onPressed: _login,
// //                         //   onPressed: () =>
// //                         //       Navigator.pushNamed(context, Constants.routeHome),
// //                       ),
// //                       if (authProvider.error != null) ...[
// //                         const SizedBox(height: 16),
// //                         Text(
// //                           authProvider.error!,
// //                           style: const TextStyle(
// //                             color: AppTheme.error,
// //                             fontSize: 14,
// //                           ),
// //                           textAlign: TextAlign.center,
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 // Register option
// //                 _buildRegisterOption(),
// //                 const SizedBox(height: 24),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeader() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       children: [
// //         // App Logo
// //         Container(
// //           width: 80,
// //           height: 80,
// //           decoration: BoxDecoration(
// //             color: AppTheme.primaryColor,
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: const Center(
// //             child: Icon(
// //               Icons.sports_basketball,
// //               size: 50,
// //               color: Colors.white,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         // App Name
// //         const Text(
// //           'WasupMate',
// //           style: TextStyle(
// //             fontSize: 28,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         // Tagline
// //         Text(
// //           'Join the sports conversation',
// //           style: TextStyle(
// //             fontSize: 16,
// //             color: Theme.of(context).textTheme.bodySmall?.color,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildRememberForgot() {
// //     return Row(
// //       children: [
// //         // Remember me checkbox
// //         Theme(
// //           data: ThemeData(
// //             unselectedWidgetColor: AppTheme.textLightSecondary,
// //           ),
// //           child: Checkbox(
// //             value: _rememberMe,
// //             activeColor: AppTheme.primaryColor,
// //             onChanged: (value) {
// //               setState(() {
// //                 _rememberMe = value ?? false;
// //               });
// //             },
// //           ),
// //         ),
// //         const Text('Remember me'),
// //         const Spacer(),
// //         // Forgot password link
// //         TextButton(
// //           onPressed: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => const ForgotPasswordScreen(),
// //               ),
// //             );
// //           },
// //           child: const Text('Forgot Password?'),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildRegisterOption() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         Text(
// //           'Don\'t have an account?',
// //           style: TextStyle(
// //             color: Theme.of(context).textTheme.bodySmall?.color,
// //           ),
// //         ),
// //         TextButton(
// //           onPressed: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => const RegisterScreen(),
// //               ),
// //             );
// //           },
// //           child: const Text('Register'),
// //         ),
// //       ],
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wasupmate/utils/constants.dart';

// import '../../config/theme.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/event_provider.dart';
// import '../../widgets/common/custom_button.dart';
// import '../../widgets/common/custom_text_field.dart';
// import '../../utils/validators.dart';
// import '../home/home_screen.dart';
// import 'register_screen.dart';
// import 'forgot_password_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _rememberMe = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       FocusScope.of(context).unfocus();

//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final eventProvider = Provider.of<EventProvider>(context, listen: false);

//       // Simulated login success
//       final bool success = true;
//       if (success) {
//         eventProvider.setMockEvents();
//         Navigator.of(context).pushReplacement(
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) =>
//                 const HomeScreen(),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               const begin = Offset(1.0, 0.0);
//               const end = Offset.zero;
//               const curve = Curves.easeOut;
//               var tween =
//                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//               var offsetAnimation = animation.drive(tween);
//               return SlideTransition(position: offsetAnimation, child: child);
//             },
//             transitionDuration: const Duration(milliseconds: 500),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _handleGoogleSignIn() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.signInWithGoogle();
//     if (authProvider.user != null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   }

//   Future<void> _handleFacebookSignIn() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.signInWithFacebook();
//     if (authProvider.user != null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: SizedBox(
//             height: size.height -
//                 MediaQuery.of(context).padding.top -
//                 MediaQuery.of(context).padding.bottom,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 48),
//                 _buildHeader(),
//                 const SizedBox(height: 40),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       CustomTextField(
//                         controller: _emailController,
//                         labelText: 'Email',
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: Validators.validateEmail,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         controller: _passwordController,
//                         labelText: 'Password',
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         obscureText: !_isPasswordVisible,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                         validator: Validators.validatePassword,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildRememberForgot(),
//                       const SizedBox(height: 24),
//                       CustomButton(
//                         text: 'Login',
//                         isLoading: authProvider.isLoading,
//                         onPressed: _login,
//                       ),
//                       if (authProvider.error != null) ...[
//                         const SizedBox(height: 16),
//                         Text(
//                           authProvider.error!,
//                           style: const TextStyle(
//                             color: AppTheme.error,
//                             fontSize: 14,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                       const SizedBox(height: 24),
//                       const Center(
//                           child: Text("OR", style: TextStyle(fontSize: 16))),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton.icon(
//                             icon: const Icon(Icons.g_mobiledata),
//                             label: const Text('Google'),
//                             onPressed: _handleGoogleSignIn,
//                           ),
//                           const SizedBox(width: 16),
//                           ElevatedButton.icon(
//                             icon: const Icon(Icons.facebook),
//                             label: const Text('Facebook'),
//                             onPressed: _handleFacebookSignIn,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 _buildRegisterOption(),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             color: AppTheme.primaryColor,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: const Center(
//             child: Icon(
//               Icons.sports_basketball,
//               size: 50,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           'WasupMate',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Join the sports conversation',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRememberForgot() {
//     return Row(
//       children: [
//         Theme(
//           data: ThemeData(
//             unselectedWidgetColor: AppTheme.textLightSecondary,
//           ),
//           child: Checkbox(
//             value: _rememberMe,
//             activeColor: AppTheme.primaryColor,
//             onChanged: (value) {
//               setState(() {
//                 _rememberMe = value ?? false;
//               });
//             },
//           ),
//         ),
//         const Text('Remember me'),
//         const Spacer(),
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const ForgotPasswordScreen(),
//               ),
//             );
//           },
//           child: const Text('Forgot Password?'),
//         ),
//       ],
//     );
//   }

//   Widget _buildRegisterOption() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text('Don\'t have an account?'),
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const RegisterScreen(),
//               ),
//             );
//           },
//           child: const Text('Register'),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasupmate/utils/constants.dart';

import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../utils/validators.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      final bool success = true; // Mocked success
      if (success) {
        eventProvider.setMockEvents();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithGoogle();
    if (authProvider.user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<void> _handleFacebookSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithFacebook();
    if (authProvider.user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            height: size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                _buildHeader(),
                const SizedBox(height: 40),
                Form(
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
                      const SizedBox(height: 16),
                      _buildRememberForgot(),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Login',
                        isLoading: authProvider.isLoading,
                        onPressed: _login,
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
                      const Center(
                          child: Text("OR", style: TextStyle(fontSize: 16))),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Image.asset('assets/images/google.png',
                              height: 20),
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
                          icon: Image.asset('assets/images/facebook.png',
                              height: 20),
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
                    ],
                  ),
                ),
                const Spacer(),
                _buildRegisterOption(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(
              Icons.sports_basketball,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'WasupMate',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join the sports conversation',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppTheme.textLightSecondary,
          ),
          child: Checkbox(
            value: _rememberMe,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
          ),
        ),
        const Text('Remember me'),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen(),
              ),
            );
          },
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }

  Widget _buildRegisterOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}

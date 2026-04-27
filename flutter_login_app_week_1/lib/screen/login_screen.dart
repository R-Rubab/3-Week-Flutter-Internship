// // import 'package:flutter/material.dart';
// // import 'home_screen.dart';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   final _formKey = GlobalKey<FormState>();

// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   void login() {
// //     if (_formKey.currentState!.validate()) {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) =>  HomeScreen(email: emailController.text)),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Login Screen"), centerTitle: true),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               const SizedBox(het: 20),

// //               // Email Field
// //               TextFormField(
// //                 controller: emailController,
// //                 decoration: const InputDecoration(
// //                   labelText: "Email",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return "Email is required";
// //                   }
// //                   // final emailRegex = RegExp(r'\(');

// //                   // final emailRegex = RegExp(
// //                   //   r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$',

// //                   // );

// //                   // if (!emailRegex.hasMatch(value)) {
// //                   //   return "Enter valid email";
// //                   // }

// //                   return null;
// //                 },
// //               ),

// //               const SizedBox(het: 20),

// //               // Password Field
// //               TextFormField(
// //                 controller: passwordController,
// //                 obscureText: true,
// //                 decoration: const InputDecoration(
// //                   labelText: "Password",
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return "Password cannot be empty";
// //                   }
// //                   return null;
// //                 },
// //               ),

// //               const SizedBox(het: 20),

// //               // Login Button
// //               ElevatedButton(onPressed: login, child: const Text("Login")),

// //               const SizedBox(het: 10),

// //               // Forgot Password Text
// //               const Text(
// //                 "Forgot Password?",
// //                 style: TextStyle(
// //                   color: Colors.blue,
// //                   decoration: TextDecoration.underline,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   String email = '';
//   String password = '';

//   bool isValidEmail(String email) {
//     return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey.shade100,
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Text(
//                     "Login",
//                     style: TextStyle(fontSize: 26, fontWet: FontWet.bold),
//                   ),
//                   SizedBox(het: 20),

//                   /// EMAIL FIELD
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: "Email",
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (value) => email = value,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Email required";
//                       }
//                       if (!isValidEmail(value)) {
//                         return "Enter valid email";
//                       }
//                       return null;
//                     },
//                   ),

//                   SizedBox(het: 15),

//                   /// PASSWORD FIELD
//                   TextFormField(
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (value) => password = value,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Password required";
//                       }
//                       return null;
//                     },
//                   ),

//                   SizedBox(het: 20),

//                   /// LOGIN BUTTON
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(double.infinity, 50),
//                     ),
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => HomeScreen(email: email),
//                           ),
//                         );
//                       }
//                     },
//                     child: Text("Login"),
//                   ),

//                   /// FORGOT PASSWORD
//                   TextButton(onPressed: () {}, child: Text("Forgot Password?")),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_login_app_week_1/screen/home_screen.dart';
import 'package:flutter_login_app_week_1/widgets/authSocial.dart';
import 'package:flutter_login_app_week_1/widgets/authTextField.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String email = '';
  String password = '';

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 01,
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 04),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Text field Email
                    AuthTextField(
                      controller: emailController,
                      text: "Enter you email",
                      icon: 'assets/images/email.png',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => emailController.text = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email required";
                        }
                        if (!isValidEmail(value)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 3),
                    //Text field Password
                    AuthTextField(
                      text: "Enter your password",
                      icon: 'assets/images/lock.png',
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      onChanged: (value) => passwordController.text = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password required";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle forgot password action
                          },
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.pink,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Perform login action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  HomeScreen(email: emailController.text),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 01,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 30),
              AuthSocialLogin(
                logo: 'assets/images/google.png',
                text: "Sign in with Google",
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              AuthSocialLogin(
                logo: 'assets/images/apple.png',
                text: "Sign in Apple",
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              AuthSocialLogin(
                logo: 'assets/images/facebook.png',
                text: "Sign in facebook",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

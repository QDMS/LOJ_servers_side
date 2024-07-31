import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lojservers/screens/home/home_screen.dart';
import 'package:lojservers/screens/auth/register_screen.dart';
import 'package:lojservers/screens/auth/widgets/global_methods.dart';
import 'package:lojservers/screens/auth/forgot_password_screen.dart';
import 'package:lojservers/screens/auth/widgets/loading_manager.dart';
import 'package:lojservers/screens/auth/widgets/firebase_consts.dart';
import 'package:lojservers/screens/auth/widgets/auth_gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _passVisibility = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    if (isValid) {
     
        _formKey.currentState!.save();
        try {
          await authInstance.signInWithEmailAndPassword(
              email: _emailController.text.toLowerCase().trim(),
              password: _passwordController.text.trim());
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
          print('Successfully Logged In');
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
          setState(() {
            _isLoading = false;
          });
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(.4),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome Back,',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login To Your Account Servers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Address
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please Enter A Valid Email Address';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.brown,
                              ),
                              labelText: 'Enter Your Email',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.brown.shade300,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                ),
                                borderRadius: BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade300),
                                borderRadius: BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // Password
                          TextFormField(
                            obscureText: _passVisibility,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a password more than 7 characters';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: _passVisibility
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.brown,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.brown,
                                      ),
                                onPressed: () {
                                  _passVisibility = !_passVisibility;
        
                                  setState(() {});
                                },
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.brown,
                              ),
                              labelText: 'Enter Your Password',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.brown.shade300,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                ),
                                borderRadius: BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade300),
                                borderRadius: BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPasswordScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AuthGradientButton(
                      icon: Icons.login,
                      buttonText: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.brown.shade800,
                          fontSize: 25,
                        ),
                      ),
                      onPress: () {
                        _submitFormOnLogin();
                      },
                      iconColor: Colors.brown.shade800,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Don\'t Have An Account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text: ' Register',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RegisterScreen();
                              },
                            ),
                          );
                                  }),
                          ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

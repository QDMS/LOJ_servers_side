import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lojservers/screens/home/home_screen.dart';
import 'package:lojservers/screens/auth/login_screen.dart';
import 'package:lojservers/screens/auth/widgets/loader.dart';
import 'package:lojservers/screens/auth/widgets/global_methods.dart';
import 'package:lojservers/screens/auth/widgets/firebase_consts.dart';
import 'package:lojservers/screens/auth/widgets/loading_manager.dart';
import 'package:lojservers/screens/auth/widgets/auth_gradient_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _employerCodeController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _eCodeFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _passVisibility = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _employerCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passFocusNode.dispose();
    _emailFocusNode.dispose();
    _eCodeFocusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    const employerCode =
        'LOJServers229'; // Replace with your actual employer code

    if (isValid) {
      if (_employerCodeController.text != employerCode) {
        // Show an error message if the employer code is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid Employer Code'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        _formKey.currentState!.save();
        try {
          await authInstance.createUserWithEmailAndPassword(
              email: _emailController.text.toLowerCase().trim(),
              password: _passwordController.text.trim());
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
          print('Successfully Registered');
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
                      'Welcome,',
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
                      'Register For Your Server Account',
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
                          // Full Name
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            controller: _fullNameController,
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This Field Is Missing';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.brown,
                              ),
                              labelText: 'Enter Your Full Name',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.brown.shade300,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                ),
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade300),
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
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
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade300),
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
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
                              _submitFormOnRegister();
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
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade300),
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // Employers Code
                          TextFormField(
                            obscureText: _passVisibility,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnRegister();
                            },
                            controller: _employerCodeController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter The Employer Code';
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
                                Icons.pin,
                                color: Colors.brown,
                              ),
                              labelText: 'Enter The Employers Code',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.brown.shade300,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                ),
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade300),
                                borderRadius:
                                    BorderRadius.circular(30).copyWith(
                                  bottomRight: const Radius.circular(0),
                                  topLeft: const Radius.circular(0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthGradientButton(
                      icon: Icons.login,
                      buttonText: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.brown.shade800,
                          fontSize: 25,
                        ),
                      ),
                      onPress: () {
                        _submitFormOnRegister();
                      },
                      iconColor: Colors.brown.shade800,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Already Have An Account?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                text: ' Login',
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
                                          return LoginScreen();
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

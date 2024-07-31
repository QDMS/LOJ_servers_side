import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:lojservers/screens/auth/widgets/utils.dart';
import 'package:lojservers/screens/auth/widgets/text_widget.dart';
import 'package:lojservers/screens/auth/widgets/global_methods.dart';
import 'package:lojservers/screens/auth/widgets/loading_manager.dart';
import 'package:lojservers/screens/auth/widgets/firebase_consts.dart';
import 'package:lojservers/screens/auth/widgets/auth_gradient_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailTextController = TextEditingController();
  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  bool _isLoading = false;
  void _forgetPassFCT() async {
    if (_emailTextController.text.isEmpty ||
        !_emailTextController.text.contains('@')) {
      GlobalMethods.errorDialog(
          subtitle: 'Please Enter A Correct Email Address!!!',
          context: context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: _emailTextController.text.toLowerCase());
        Fluttertoast.showToast(
            msg: "An Email Has Been Sent To Your Email Address.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.brown.shade300,
            fontSize: 16.0);
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
          subtitle: '${error.message}',
          context: context,
        );
      } catch (error) {
        GlobalMethods.errorDialog(
          subtitle: '$error',
          context: context,
        );
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
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      // backgroundColor: Colors.blue,
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
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                    child: const Icon(
                      IconlyLight.arrowLeft2,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Forget password',
                    color: Colors.white,
                    textSize: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.brown),
                    cursorColor: Colors.brown,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      labelText: 'Enter Your Email',
                      labelStyle: TextStyle(color: Colors.brown, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.brown.withOpacity(.05),
                        ),
                        borderRadius: BorderRadius.circular(30).copyWith(
                          bottomRight: const Radius.circular(0),
                          topLeft: const Radius.circular(0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.brown.withOpacity(.05)),
                        borderRadius: BorderRadius.circular(30).copyWith(
                          bottomRight: const Radius.circular(0),
                          topLeft: const Radius.circular(0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthGradientButton(
                    icon: Icons.lock_reset_rounded,
                    buttonText: Text(
                      'Reset Now',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 51, 37, 32),
                        fontSize: 20,
                      ),
                    ),
                    onPress: () {
                      _forgetPassFCT();
                    },
                    iconColor: const Color.fromARGB(255, 51, 37, 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

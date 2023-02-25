import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { signUp, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 0.5),
                Color.fromRGBO(255, 188, 117, 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
        ),
        SingleChildScrollView(
          child: SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 94,
                    ),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'MyShop',
                      style: GoogleFonts.anton(
                        fontSize: 50,
                        // color: Theme.of(context).textTheme.titleMedium!.color,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: const AuthCard(),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occurred'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      //Invalid Case
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        //Login User
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        //Sign Up user
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: Container(
        height:
            _authMode == AuthMode.signUp ? pageHeight * 0.36 : pageHeight * 0.3,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signUp
              ? pageHeight * 0.36
              : pageHeight * 0.3,
        ),
        width: pageWidth * 0.9,
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid Email !';
                    }
                  },
                  onSaved: (newValue) {
                    _authData['email'] = newValue!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too Short';
                    }
                  },
                  onSaved: (newValue) {
                    _authData['password'] = newValue!;
                  },
                ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration:
                        const InputDecoration(labelText: 'confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Password do not match';
                            }
                            //remove this thing if password match doesn't work
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: pageHeight * 0.025,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      ),
                      textStyle: MaterialStatePropertyAll(
                        TextStyle(
                          color: Theme.of(context).textTheme.labelLarge!.color,
                        ),
                      ),
                    ),
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: ButtonStyle(
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: MaterialStatePropertyAll(
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'SIGN UP' : 'LOGIN',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

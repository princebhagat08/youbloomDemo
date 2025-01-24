import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:youbloomdemo/bloc/login_bloc/login_bloc.dart';
import 'package:youbloomdemo/bloc/login_bloc/login_event.dart';
import 'package:youbloomdemo/bloc/login_bloc/login_state.dart';
import 'package:youbloomdemo/config/images/images.dart';
import 'package:youbloomdemo/config/text_style/text_style.dart';
import '../../config/color/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPhone = true;
  String? phoneNumber;
  bool isLoading = false;


  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (isPhone) {
        print('Logging in with phone: $phoneNumber');
      } else {
        print('Logging in with email: ${_emailController.text}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor.withValues(alpha: 0.5),
              AppColor.offWhite
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: mq.height * 0.1,
            ),
            child: Column(
              children: [
                // Logo/Branding Section
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Image.asset(loginImg),
                      const SizedBox(height: 20),
                      Text('Welcome Back', style: xLargeBoldText),
                    ],
                  ),
                ),

                // Login Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.grey.withValues(alpha: 0.5),
                        spreadRadius: 5,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Toggle Buttons
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context,state){
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColor.grey.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => context.read<LoginBloc>().add(LoginWithPhone()),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: state.isLoginWithPhone
                                              ? AppColor.primaryColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: state.isLoginWithPhone
                                              ? [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                            ),
                                          ]
                                              : null,
                                        ),
                                        child: Text(
                                          'Phone',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: state.isLoginWithPhone
                                                ? AppColor.whiteColor
                                                : AppColor.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => context.read<LoginBloc>().add(LoginWithEmail()),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          color: !state.isLoginWithPhone
                                              ? AppColor.primaryColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: !state.isLoginWithPhone?
                                          [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                            ),
                                          ]
                                              : null,
                                        ),
                                        child: Text(
                                          'Email',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: !state.isLoginWithPhone
                                                ? AppColor.whiteColor
                                                : AppColor.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },

                        ),
                        const SizedBox(height: 30),

                        // Input Fields
                        BlocBuilder<LoginBloc,LoginState>(
                            builder: (context,state){
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 450),
                            child: state.isLoginWithPhone
                                ? IntlPhoneField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle:
                                TextStyle(color: AppColor.blackColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: AppColor.primaryColor
                                          .withValues(alpha: 0.4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: AppColor.primaryColor
                                          .withValues(alpha: 0.4)),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                errorStyle:
                                const TextStyle(color: Colors.red),
                              ),
                              initialCountryCode: 'IN',
                              invalidNumberMessage: 'Invalid phone number',
                              onChanged: (phone){
                                  if(phone.isValidNumber()){

                                  }
                              },
                            )
                                : Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle:
                                    TextStyle(color: AppColor.blackColor),
                                    prefixIcon: Icon(Icons.email_outlined,
                                        color: AppColor.blackColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: AppColor.primaryColor
                                              .withValues(alpha: 0.4)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle:
                                    TextStyle(color: AppColor.blackColor),
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: AppColor.blackColor),
                                    suffixIcon: Icon(Icons.visibility_off,
                                        color: AppColor.blackColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: AppColor.primaryColor
                                              .withValues(alpha: 0.4)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  validator: (value) {
                                   if(value == null || value.isEmpty){
                                     return 'Please enter password';
                                   }
                                    return null;
                                  },
                                ),
                              ],
                            )
                          );
                        }),
                        const SizedBox(height: 30),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

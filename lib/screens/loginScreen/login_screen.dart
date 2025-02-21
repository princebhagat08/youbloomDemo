import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:youbloomdemo/bloc/language_bloc/language_bloc.dart';
import 'package:youbloomdemo/bloc/login_bloc/login_bloc.dart';
import 'package:youbloomdemo/bloc/login_bloc/login_event.dart';
import 'package:youbloomdemo/bloc/login_bloc/login_state.dart';
import 'package:youbloomdemo/config/images/images.dart';
import 'package:youbloomdemo/config/internationalization/language.dart';
import 'package:youbloomdemo/config/routes/routes_name.dart';
import 'package:youbloomdemo/config/text_style/text_style.dart';
import 'package:youbloomdemo/utils/custom_widgets/custom_alert_dialog.dart';
import 'package:youbloomdemo/utils/custom_widgets/custom_loader.dart';
import 'package:youbloomdemo/utils/enums.dart';
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
  bool isValidPhoneNumber = false;
  String completeNumber = '';



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
                _logo(),

                // Login Card
                _loginCard(),
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
    _passwordController.dispose();
    super.dispose();
  }



//   Logo/Branding section
  Widget _logo(){
    final language = context.read<LanguageBloc>().language;
    return  Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Image.asset(loginImg),
          const SizedBox(height: 20),
          Text( language.getText('welcome_back'), style: xLargeBoldText),
        ],
      ),
    );
}

// Login Cart
 Widget _loginCard(){
    return  Container(
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
            _toggleButton(),
            const SizedBox(height: 30),

            // Input Fields
            _inputField(),
            const SizedBox(height: 30),

            // Login Button
            _loginButton()

          ],
        ),
      ),
    );
 }


//  Toggle Button
  Widget _toggleButton(){
    final language = context.read<LanguageBloc>().language;
    return  BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
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
                  onTap: () => context
                      .read<LoginBloc>()
                      .add(LoginWithPhone()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12),
                    decoration: BoxDecoration(
                      color: state.isLoginWithPhone
                          ? AppColor.primaryColor
                          : Colors.transparent,
                      borderRadius:
                      BorderRadius.circular(8),
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
                      language.getText('phone'),
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
                child: InkWell(
                  onTap: () => context
                      .read<LoginBloc>()
                      .add(LoginWithEmail()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12),
                    decoration: BoxDecoration(
                      color: !state.isLoginWithPhone
                          ? AppColor.primaryColor
                          : Colors.transparent,
                      borderRadius:
                      BorderRadius.circular(8),
                      boxShadow: !state.isLoginWithPhone
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
                      language.getText('email'),
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
    );
  }

  // Input field
  Widget _inputField(){
    final language = context.read<LanguageBloc>().language;
    return   BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isLoginWithPhone
                  ? IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: language.getText('phone_number'),
                  labelStyle: TextStyle(
                      color: AppColor.blackColor),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: AppColor.primaryColor
                            .withValues(alpha: 0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10),
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
                invalidNumberMessage:
                language.getText('invalid_phone_number'),
                onChanged: (phone) {
                  try {
                    isValidPhoneNumber =
                        phone.isValidNumber();
                    completeNumber = phone.completeNumber;
                  } catch (e) {
                    isValidPhoneNumber = false;
                  }
                },
              )
                  : Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: language.getText('email'),
                      labelStyle: TextStyle(
                          color: AppColor.blackColor),
                      prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColor.blackColor),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColor.primaryColor
                                .withValues(alpha: 0.4)),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return language.getText('please_enter_email');
                      }
                      if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return language.getText('please_enter_valid_email');
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: state.isHidePassword,
                    decoration: InputDecoration(
                      labelText: language.getText('password'),
                      labelStyle: TextStyle(
                          color: AppColor.blackColor),
                      prefixIcon: Icon(Icons.lock_outline,
                          color: AppColor.blackColor),
                      suffixIcon: IconButton(icon:  Icon(
                        state.isHidePassword ? Icons.visibility_off:Icons.visibility,
                        color: AppColor.blackColor,),
                        onPressed: ()=>context.read<LoginBloc>().add(HidePassword()),),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppColor.primaryColor
                                .withValues(alpha: 0.4)),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return language.getText('please_enter_password');
                      }
                      return null;
                    },
                  ),
                ],
              ));
        });
  }

//   Login Button
 Widget _loginButton(){
   final language = context.read<LanguageBloc>().language;
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (current, previous)=>current.loginStatus != previous.loginStatus,
      listener:(context,state){
        if(state.loginStatus == LoadingStatus.error){
          showDialog(
              context: context,
              builder: (context) =>
                  CustomAlertDialog(
                    title: "Error",
                    content: Text(language.getText(state.errorMessage??'something_went_wrong')),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop();
                          },
                          child: Text('Ok')),
                    ],
                  ));
        }
        if(state.loginStatus == LoadingStatus.success){
          if(state.isLoginWithPhone){
            Navigator.pushReplacementNamed(
              context, RoutesName.otp,);
          }else{
            Fluttertoast.showToast(msg: language.getText('login_successful'));
            Navigator.pushReplacementNamed(context, RoutesName.home);
          }

        }
      },
      child:  BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (state.isLoginWithPhone) {
                    if (isValidPhoneNumber) {
                      // sending otp via firebase
                      
                      // context
                      //     .read<LoginBloc>()
                      //     .add(SendPhoneOTP(completeNumber));

                    //   Sending mock otp
                      context.read<LoginBloc>().add(SendMockOtp(completeNumber));


                    } else {
                      Fluttertoast.showToast(
                          msg: language.getText('enter_valid_phone_number'));
                    }
                  } else {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(ValidateUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim()));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: state.loginStatus == LoadingStatus.loading
                    ? CustomLoader(
                  primaryColor: AppColor.whiteColor,
                )
                    : Text(
                  language.getText('login'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            );
          }),

    );
 }

}

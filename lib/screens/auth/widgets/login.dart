import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_textformfield.dart';
import 'package:eco_collect/constants/error_handler_values.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/routes/kroutes.dart';

import 'package:eco_collect/screens/mother_earth_video.dart/mother_earth_video.dart';

import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final String _errorText = '*This field is required.';

  String? _usernameError;
  String? _emailError;
  String? _passwordError;

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const ReusableBgImage(
              assetImageSource: KLottie.nightRiverBoatMountains,
              isLottie: true,
            ),
            LottieBuilder.asset(KLottie.birds),
            LottieBuilder.asset(KLottie.parrots),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: KTheme.transparencyBlack),
                        child: const Text(
                          'Login',
                          style: KTheme.titleStyle,
                        ),
                      ),
                      Hero(
                        tag: 'authEarth',
                        child: Lottie.asset(
                          KLottie.earthHeadphones,
                          height: 60.0,
                          width: 60.0,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: ListView(shrinkWrap: true, children: <Widget>[
                        ReusableTextFormField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          errorText: _usernameError,
                          label: 'Username',
                          suffixIcon: const Icon(Icons.alternate_email),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ReusableTextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          errorText: _emailError,
                          keyboardType: TextInputType.emailAddress,
                          addEmailValidation: true,
                          label: 'Email',
                          suffixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ReusableTextFormField(
                          controller: _passController,
                          textInputAction: TextInputAction.done,
                          obscureText: isPasswordHidden,
                          errorText: _passwordError,
                          label: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                            icon: isPasswordHidden
                                ? const Icon(Icons.remove_red_eye)
                                : const Icon(Icons.emergency),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 5.0),
                    child: ReusableButton(
                      onTap: () async {
                        try {
                          KLoadingToast.startLoading();
                          if (_usernameController.text.trim().isEmpty ||
                              _emailController.text.trim().isEmpty ||
                              _passController.text.trim().isEmpty) {
                            _usernameError =
                                _usernameController.text.trim().isEmpty
                                    ? _errorText
                                    : null;
                            _emailError = _emailController.text.trim().isEmpty
                                ? _errorText
                                : null;
                            _passwordError = _passController.text.trim().isEmpty
                                ? _errorText
                                : null;
                            setState(() {});
                          } else if (!_emailController.text.contains('@')) {
                            _emailError = 'Invalid email address';
                            _usernameError = null;
                            _passwordError = null;
                            setState(() {});
                          } else if (_passController.text.length < 8) {
                            _passwordError =
                                'password must be at least 8 characters long.';
                            _usernameError = null;
                            _emailError = null;
                            setState(() {});
                          } else {
                            _usernameError = null;
                            _emailError = null;
                            _passwordError = null;
                            setState(() {});
                            final String username =
                                _usernameController.text.trim();
                            final String email = _emailController.text.trim();
                            final String pass = _passController.text.trim();
                            final String isOk =
                                await FirebaseApis().loginFirebase(
                              context: context,
                              username: username,
                              emailAddress: email,
                              password: pass,
                            );
                            if (isOk == ErrorsHandlerValues.goodToLogin) {
                              if (context.mounted) {
                                KRoute.pushRemove(
                                  context: context,
                                  page: const MotherEarthVideo(
                                    showSkipWarning: false,
                                  ),
                                );
                              }
                            } else if (isOk ==
                                ErrorsHandlerValues.passOrEmailInvalid) {
                              _usernameError = null;
                              _emailError =
                                  ErrorsHandlerValues.passOrEmailInvalid;
                              _passwordError =
                                  ErrorsHandlerValues.passOrEmailInvalid;
                              setState(() {});
                            } else if (isOk ==
                                ErrorsHandlerValues.usernameInvalid) {
                              _usernameError =
                                  ErrorsHandlerValues.usernameInvalid;
                              _emailError = null;
                              _passwordError = null;
                              setState(() {});
                            } else if (isOk == ErrorsHandlerValues.bannedUser) {
                              KLoadingToast.showCustomDialog(
                                message: ErrorsHandlerValues.bannedUser,
                                toastType: KenumToastType.error,
                              );
                              setState(() {});
                            } else {
                              KLoadingToast.showCustomDialog(
                                message:
                                    'Something went wrong, please try again later.',
                                toastType: KenumToastType.error,
                              );
                            }
                          }
                        } catch (e) {
                          KLoadingToast.showCustomDialog(
                              message: 'Something went wrong.',
                              toastType: KenumToastType.error);
                        } finally {
                          KLoadingToast.stopLoading();
                        }
                      },
                      label: 'Login',
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
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

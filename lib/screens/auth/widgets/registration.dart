import 'package:country_list_pick/country_list_pick.dart';
import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/constants/error_handler_values.dart';
import 'package:eco_collect/constants/kassets.dart';

import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';

import 'package:eco_collect/screens/mother_earth_video.dart/mother_earth_video.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eco_collect/components/reusable_textformfield.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _regFormKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  String _country = 'India';

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              const ReusableBgImage(
                assetImageSource: KLottie.nightRiverBoatMountains,
                isLottie: true,
              ),
              LottieBuilder.asset(KLottie.parrots),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: KTheme.transparencyBlack),
                          child: const Text(
                            'Register',
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
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Form(
                            key: _regFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                ReusableTextFormField(
                                  controller: _fullNameController,
                                  textInputAction: TextInputAction.next,
                                  label: 'Full name',
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\s]')),
                                  ],
                                ),
                                Commonfunctions.gapMultiplier(),
                                ReusableTextFormField(
                                  controller: _usernameController,
                                  textInputAction: TextInputAction.next,
                                  label: 'username',
                                  suffixIcon: const Icon(Icons.alternate_email),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\d]')),
                                  ],
                                ),
                                Commonfunctions.gapMultiplier(),
                                ReusableTextFormField(
                                  controller: _emailController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  label: 'Email',
                                  suffixIcon: const Icon(Icons.email),
                                  addEmailValidation: true,
                                ),
                                Commonfunctions.gapMultiplier(),
                                ReusableTextFormField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => _passwordValidation(
                                      value, _passwordController),
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
                                  obscureText: isPasswordHidden,
                                ),
                                Commonfunctions.gapMultiplier(),
                                ReusableTextFormField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirm Password',
                                  textInputAction: TextInputAction.next,
                                  validator: (value) => _passwordValidation(
                                      value, _confirmPasswordController),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isConfirmPasswordHidden =
                                            !isConfirmPasswordHidden;
                                      });
                                    },
                                    icon: isConfirmPasswordHidden
                                        ? const Icon(Icons.remove_red_eye)
                                        : const Icon(Icons.emergency),
                                  ),
                                  obscureText: isConfirmPasswordHidden,
                                ),
                                Commonfunctions.gapMultiplier(),
                                CountryListPick(
                                    pickerBuilder: (context, countryCode) {
                                      return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: KTheme.transparencyBlack,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                countryCode?.name ?? _country,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Image.asset(
                                                countryCode!.flagUri.toString(),
                                                package: 'country_list_pick',
                                                height: 25.0,
                                                width: 25.0,
                                                fit: BoxFit.contain,
                                              ),
                                            ],
                                          ));
                                    },
                                    theme: CountryTheme(
                                      isShowFlag: true,
                                      isShowTitle: true,
                                      isShowCode: false,
                                      isDownIcon: true,
                                      showEnglishName: true,
                                    ),
                                    initialSelection: '+91',
                                    onChanged: (CountryCode? code) {
                                      setState(() {
                                        _country = code?.name ?? 'India';
                                      });
                                    },
                                    // Whether to allow the widget to set a custom UI overlay
                                    useUiOverlay: false,
                                    useSafeArea: true),
                                Commonfunctions.gapMultiplier(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ReusableButton(
                                    label: 'Register',
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    onTap: _submitForm,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _passwordValidation(value, TextEditingController controller) {
    if (controller.text.trim().length < 8 ||
        controller.text.trim().length > 16) {
      return "It should be 8 to 16 characters long.";
    } else if (_confirmPasswordController.text.trim() !=
        _passwordController.text.trim()) {
      return 'Password not matching';
    }
    return null;
  }

  void _submitForm() async {
    if (_regFormKey.currentState!.validate()) {
      final res = await FirebaseApis().registerFirebase(
        context: context,
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        emailAddress: _emailController.text.trim(),
        country: _country,
        password: _passwordController.text.trim(),
      );
      if (res == ErrorsHandlerValues.goodToRegister) {
        // If all things went successfully
        Provider.of<UserDataProvider>(navigatorKey.currentContext!,
                listen: false)
            .setIsFirstTimeUser = true;
        KRoute.pushRemove(
            context: navigatorKey.currentContext!,
            page: const MotherEarthVideo());
      }
    }
  }
}

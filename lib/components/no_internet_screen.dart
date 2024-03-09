// ignore_for_file: invalid_return_type_for_catch_error

import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/constants/error_handler_values.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/my_game.dart';
import 'package:eco_collect/services/connectivity_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LottieBuilder.asset(KLottie.noInternet),
                Commonfunctions.gapMultiplier(),
                Text(
                  ErrorsHandlerValues.noInternet,
                  textAlign: TextAlign.center,
                  style: KTheme.subtitleStyle.copyWith(
                    letterSpacing: 2.0,
                    color: Colors.black,
                  ),
                ),
                Commonfunctions.gapMultiplier(),
                ReusableButton(
                  label: 'Try Again',
                  mainAxisAlignment: MainAxisAlignment.center,
                  onTap: () async {
                    ConnectivityServices()
                        .checkInternetConnectivity()
                        .then((hasInternet) {
                      if (hasInternet) {
                        runApp(const MyGame());
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

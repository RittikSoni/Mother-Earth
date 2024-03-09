import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:flutter/material.dart';

class ErrorApp extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? retryLabel;
  const ErrorApp({super.key, this.onRetry, this.retryLabel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong, Please try again.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              onRetry == null
                  ? Container()
                  : ReusableButton(
                      bg: KTheme.lightBg,
                      onTap: onRetry ??
                          () {
                            // You can implement a retry mechanism here, or navigate to another screen.
                            // For a retry, you can re-run the initialization code.
                            // For example: runApp(MyApp());
                          },
                      label: retryLabel ?? 'Retry',
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

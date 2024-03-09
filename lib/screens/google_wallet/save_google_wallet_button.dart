// import 'package:eco_collect/constants/kenums.dart';
// import 'package:eco_collect/constants/kstrings.dart';
// import 'package:eco_collect/constants/ktheme.dart';
// import 'package:eco_collect/providers/level_provider.dart';
// import 'package:eco_collect/providers/user_provider.dart';
// import 'package:eco_collect/utils/common_functions.dart';
// import 'package:eco_collect/utils/kloading.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_wallet/google_wallet.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:uuid/uuid.dart';

// class SaveGoogleWalletButton extends StatefulWidget {
//   const SaveGoogleWalletButton({super.key, this.height});
//   final double? height;

//   @override
//   State<SaveGoogleWalletButton> createState() => _SaveGoogleWalletButtonState();
// }

// class _SaveGoogleWalletButtonState extends State<SaveGoogleWalletButton> {
//   final googleWallet = GoogleWallet();
//   String? jwt;

//   bool? _available = false;
//   String _text = 'Loading';
//   Color? _textColor;

//   @override
//   void initState() {
//     super.initState();
//     _checkAvailable();
//     _generateJwt();
//   }

//   _generateJwt() {
//     final userData =
//         Provider.of<UserDataProvider>(context, listen: false).getUserData;
//     final levelProvider = Provider.of<LevelProvider>(context, listen: false);

//     final currentLevelData = levelProvider.getPlayerCurrentHeroLevelData(
//         currentTrophies: userData?.trophies);
//     final String currentLevel = levelProvider
//         .getXpLevelDetails(currentXP: userData?.xp ?? 0)
//         .currentLevel
//         .toString();

//     final int passIat = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//     Map<String, dynamic> payload = {
//       "iss": KStrings.iss,
//       "aud": "google",
//       "typ": "savetowallet",
//       "iat": passIat,
//       "origins": ["www.example.com"],
//       "payload": {
//         "genericObjects": [
//           {
//             "id": "${KStrings.issuerId}.${const Uuid().v4()}",
//             "classId": "${KStrings.issuerId}.${KStrings.genericClassId}",
//             "logo": {
//               "sourceUri": {"uri": KStrings.passLogo},
//               "contentDescription": {
//                 "defaultValue": {
//                   "language": "en-US",
//                   "value": KStrings.passLogoDescription
//                 }
//               }
//             },
//             "cardTitle": {
//               "defaultValue": {
//                 "language": "en-US",
//                 "value": "@${userData?.username}"
//               }
//             },
//             "subheader": {
//               "defaultValue": {
//                 "language": "en-US",
//                 "value": "Mother Earth - Planet Hero"
//               }
//             },
//             "header": {
//               "defaultValue": {
//                 "language": "en-US",
//                 "value": "${userData?.fullName}"
//               }
//             },
//             "textModulesData": [
//               {
//                 "id": "badge",
//                 "header": "Badge",
//                 "body": Commonfunctions.formattedTierName(currentLevelData.tier)
//               },
//               {"id": "level", "header": "Level", "body": currentLevel}
//             ],
//             "barcode": {
//               "type": "QR_CODE",
//               "value": "BARCODE_VALUE",
//               "alternateText": "Eco-collect"
//             },
//             "hexBackgroundColor": "#1ab725",
//             "heroImage": {
//               "sourceUri": {"uri": KStrings.passHeroImage},
//               "contentDescription": {
//                 "defaultValue": {
//                   "language": "en-US",
//                   "value": KStrings.passHeroImageDescription
//                 }
//               }
//             }
//           }
//         ]
//       }
//     };

//     setState(() {
//       jwt = Commonfunctions.generateJwt(payload: payload);
//     });
//   }

//   _checkAvailable() async {
//     bool? available;
//     String text;
//     try {
//       available = await googleWallet.isAvailable();
//       text = _getGoogleWalletAvailabiltyText(isAvailable: available);
//     } on PlatformException catch (e) {
//       text = "Error: '${e.message}'.";
//     }
//     setState(() {
//       _available = available;
//       _text = text;
//     });
//   }

//   String _getGoogleWalletAvailabiltyText({required bool? isAvailable}) {
//     switch (isAvailable) {
//       case true:
//         setState(() {
//           _textColor = KTheme.success;
//         });
//         return "Google Wallet is available!";

//       case false:
//         setState(() {
//           _textColor = KTheme.error;
//         });
//         return "Google Wallet is Unavailable.";

//       default:
//         return "Something went wrong, please try again.";
//     }
//   }

//   _savePass() async {
//     bool? saved = false;
//     String? text;
//     try {
//       if (jwt != null) {
//         if (_available == true) {
//           saved = await googleWallet.savePassesJwt(jwt!);
//           text = "Pass saved: $saved";
//         } else {
//           // Wallet unavailable,
//           // fall back to saving pass via web
//           await _savePassBrowser();
//           text = "Opened Google Wallet via web";
//         }
//       } else {
//         // Throw error jwt is null
//       }
//     } on PlatformException catch (e) {
//       text = "Error: '${e.message}'.";
//     }
//     if (text != null) {
//       setState(() {
//         _text = text!;
//       });
//     }
//   }

//   _savePassBrowser() async {
//     String url = "https://pay.google.com/gp/v/save/$jwt";
//     try {
//       await launchUrl(Uri.parse(url));
//     } catch (e) {
//       KLoadingToast.showToast(
//           msg: 'Something went wrong, Please try again later.',
//           toastType: KenumToastType.error);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           GoogleWalletButton(
//             style: GoogleWalletButtonStyle.condensed,
//             height: widget.height ?? 90,
//             onPressed: _savePass,
//           ),
//           Text(
//             _text,
//             style: TextStyle(
//               color: _textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

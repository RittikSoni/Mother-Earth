import 'package:eco_collect/models/user_data_model.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class GoogleWalletThings {
  static final UserDataModel? userData =
      Provider.of<UserDataProvider>(navigatorKey.currentContext!, listen: false)
          .getUserData;

  static final levelProvider =
      Provider.of<LevelProvider>(navigatorKey.currentContext!, listen: false);

  static final currentLevelData = levelProvider.getPlayerCurrentHeroLevelData(
      currentTrophies: userData?.trophies);
  static final String currentLevel = levelProvider
      .getXpLevelDetails(currentXP: userData?.xp ?? 0)
      .currentLevel
      .toString();

  static const String iss = 'rtestinga@gmail.com';
  // 'rex-181@planet-hero-411711.iam.gserviceaccount.com';
  static const String issuerId = '3388000000022314630';
  static const String genericClassId = 'motherEarthHero';
  static const String hexBg = '#1ab725';
  static const String passLogo =
      "https://firebasestorage.googleapis.com/v0/b/eco-collect-32195.appspot.com/o/motherEarthGoogleWallet%2Fearth.png?alt=media";
  static const String passLogoTitle = 'Mother Earth Hero';
  static const String passLogoDescription = 'Mother Earth - Planet Hero';

  static const String passHeroImage =
      "https://firebasestorage.googleapis.com/v0/b/eco-collect-32195.appspot.com/o/motherEarthGoogleWallet%2FMother%20earth%20google%20wallet%20hero%20image.png?alt=media";
  static final String uuid = const Uuid().v4();

  static final String payload = """ 
    {
      "iss": "$iss",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
         "genericClasses": [
      {
        "id": "$issuerId.$genericClassId",
        "classTemplateInfo": {
          "cardTemplateOverride": {
            "cardRowTemplateInfos": [
              {
                "twoItems": {
                  "startItem": {
                    "firstValue": {
                      "fields": [
                        {
                          "fieldPath": "object.textModulesData['badge']"
                        }
                      ]
                    }
                  },
                  "endItem": {
                    "firstValue": {
                      "fields": [
                        {
                          "fieldPath": "object.textModulesData['level']"
                        }
                      ]
                    }
                  }
                }
              }
            ]
          }
        }
      }
    ],
        "genericObjects": [
          {
            "id": "$issuerId.$uuid",
            "classId": "$issuerId.$genericClassId",
            "logo": {
              "sourceUri": {
                "uri": "$passLogo"
              }
            },
            "cardTitle": {
              "defaultValue": {
                "language": "en",
                "value": "@${userData?.username}"
              }
            },

            "subheader": {
              "defaultValue": {
                "language": "en",
                "value": "$passLogoDescription"
              }
            },
            "header": {
              "defaultValue": {
                "language": "en",
                "value": "${userData?.fullName}"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "Congratulations! You've successfully accessed your GreenBadge in Google Wallet. Your environmental achievements, including your contributions, are now ready to be showcased with pride. Keep up the great work!"
            },
            "hexBackgroundColor": "$hexBg",
            "heroImage": {
              "sourceUri": {
                "uri": "$passHeroImage"
              }
            },
            "textModulesData": [
              {
                "id": "badge",
                "header": "Badge",
                "body": "${Commonfunctions.formattedTierName(currentLevelData.tier)}"
              },
              {"id": "level", "header": "Level", "body": "$currentLevel"}
            ]
          }
        ]
      }
    }
""";
}

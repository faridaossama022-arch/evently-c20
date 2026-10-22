import 'package:evently_c20/core/resources/routes_manager.dart';
import 'package:evently_c20/core/resources/strings_manager.dart';
import 'package:evently_c20/core/reusable_components/custom_button.dart';
import 'package:evently_c20/providers/theme_provider.dart';
import 'package:evently_c20/ui/start/widgets/language_switch.dart';
import 'package:evently_c20/ui/start/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/assets_manager.dart';
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}
class _StartScreenState extends State<StartScreen> {
  String  selectedLang = "en";
  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AssetsManager.logo,
          color: Theme.of(context).colorScheme.primary,
          width: screenWidth*0.45,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AssetsManager.beingCreative,color: Theme.of(context).colorScheme.onPrimary,),
            Text(StringsManager.startTitle,style: Theme.of(context).textTheme.titleMedium,),
            Text(StringsManager.startDesc,style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: 16,),
            Row(
              children: [
                Text(StringsManager.language,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),),
                Spacer(),
                LanguageSwitch(title: "English",languageCode: "en",selectedLanguage: selectedLang,),
                SizedBox(width: 8,),
                LanguageSwitch(title: "Arabic",languageCode: "ar",selectedLanguage: selectedLang,),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Text(StringsManager.theme,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),),
                Spacer(),
                ThemeSwitch(iconPath: provider.themeMode == ThemeMode.light
                    ?AssetsManager.sunSelected
                    :AssetsManager.sun,
                  mode: ThemeMode.light,),
                SizedBox(width: 8,),
                ThemeSwitch(iconPath: provider.themeMode == ThemeMode.dark
                    ?AssetsManager.moonSelected
                    :AssetsManager.moon,
                  mode: ThemeMode.dark,),
              ],
            ),
            SizedBox(height: 24,),
            CustomButton(title: StringsManager.startActionTitle, onClick: () {
              Navigator.pushReplacementNamed(context, RoutesManager.onboarding);
            },)
          ],
        ),
      ),
    );
  }
}
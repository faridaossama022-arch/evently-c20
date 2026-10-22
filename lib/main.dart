import 'package:evently_c20/core/resources/app_theme.dart';
import 'package:evently_c20/core/resources/routes_manager.dart';
import 'package:evently_c20/core/services/auth_service.dart';
import 'package:evently_c20/providers/theme_provider.dart';
import 'package:evently_c20/providers/user_provider.dart';
import 'package:evently_c20/ui/add_event/screen/add_event_screen.dart';
import 'package:evently_c20/ui/event_details/screen/event_details_screen.dart';
import 'package:evently_c20/ui/forget_password/screen/forget_password_screen.dart';
import 'package:evently_c20/ui/home/screen/home_screen.dart';
import 'package:evently_c20/ui/onboarding/screen/onboarding_screen.dart';
import 'package:evently_c20/ui/signin/screen/signin_screen.dart';
import 'package:evently_c20/ui/signup/screen/signup_screen.dart';
import 'package:evently_c20/ui/start/screen/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:evently_c20/ui/edit_event/screen/edit_event_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.init();
  runApp(ChangeNotifierProvider(
      create: (BuildContext context)=>ThemeProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:AppTheme.lightTheme ,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.themeMode,
      routes: {
        RoutesManager.start:(context)=>StartScreen(),
        RoutesManager.onboarding:(context)=>OnboardingScreen(),
        RoutesManager.signup:(context)=>SignupScreen(),
        RoutesManager.signIn:(context)=>SignInScreen(),
        RoutesManager.forgetPassword:(context)=>ForgetPasswordScreen(),
        RoutesManager.addevent:(context)=>AddEventScreen(),
        RoutesManager.eventDetails:(context)=>EventDetailsScreen(),
        RoutesManager.editEvent:(context)=>EditEventScreen(),
        RoutesManager.home:(context)=>ChangeNotifierProvider(
            create: (context) => UserProvider()..setUserValue(),
            child: HomeScreen())
      },
      initialRoute: FirebaseAuth.instance.currentUser!=null
          ?RoutesManager.home
          :RoutesManager.start,
    );
  }
}
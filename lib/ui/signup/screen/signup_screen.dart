import 'package:evently_c20/core/remote/network/firestore_manager.dart';
import 'package:evently_c20/core/resources/app_constants.dart';
import 'package:evently_c20/core/resources/dialog_utils.dart';
import 'package:evently_c20/core/resources/strings_manager.dart';
import 'package:evently_c20/core/reusable_components/custom_button.dart';
import 'package:evently_c20/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evently_c20/model/user.dart' as usermodel;
import 'package:flutter/material.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/routes_manager.dart';
import '../../../core/reusable_components/custom_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AssetsManager.logo,
          color: Theme.of(context).colorScheme.primary,
          width: screenWidth*0.45,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(StringsManager.createAccTitle,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 24,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return "Name can't empty";
                    }
                    return null;
                  },
                  hint: "Enter your name",
                  prefixPath: AssetsManager.profile,
                  controller: nameController,
                  keyboard: TextInputType.name,
                ),
                SizedBox(height: 16,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return "Email can't empty";
                    }
                    if(!RegExp(AppConstants.emailRegex).hasMatch(value)){
                      return "Invalid email";
                    }
                    return null;
                  },
                  hint: "Enter your email",
                  prefixPath: AssetsManager.email,
                  controller: emailController,
                  keyboard: TextInputType.emailAddress,
                ),
                SizedBox(height: 16,),
                CustomField(
                  validation: (value) {
                    if(value==null || value.isEmpty){
                      return "Password can't empty";
                    }
                    if(value.length<8){
                      return "Password can't be less than 8 characters";
                    }
                    return null;
                  },
                  isPassword: true,
                  hint: "Enter your password",
                  prefixPath: AssetsManager.lock,
                  controller: passController,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 16,),
                CustomField(
                  isPassword: true,
                  validation: (value) {
                    if(value != passController.text){
                      return "Passwords don't match";
                    }
                    return null;
                  },
                  hint: "Confirm your password",
                  prefixPath: AssetsManager.lock,
                  controller: confirmPassController,
                  keyboard: TextInputType.text,
                ),
                SizedBox(height: 52,),

                CustomButton(title: "Sign Up", onClick: () {
                  if(formKey.currentState?.validate()??false){
                    createNewAccount();
                  }
                },),
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall?.copyWith(
                        fontSize: 14
                    ),),
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(RoutesManager.signIn);
                        },
                        child: Text("Login",style:Theme.of(context).textTheme.titleSmall)
                    ),
                  ],),
                SizedBox(height: 8,),
                Center(
                  child: Text("Or",style: Theme.of(context).textTheme.titleSmall,),
                ),
                SizedBox(height: 16,),
                InkWell(
                  onTap: () {
                    signUpWithGoogle();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AssetsManager.google, width: 24, height: 24,),
                        SizedBox(width: 8,),
                        Text("Sign up with Google",style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                        ),),
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

  createNewAccount()async{
    try{
      DialogUtils.showLoadingDialog(context);
      var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text
      );
      await FirestoreManager.saveUser(usermodel.User(
          id: credential.user?.uid,
          name: nameController.text,
          email: emailController.text,
          favorites: []
      ));
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(RoutesManager.home);
    }on FirebaseAuthException catch (e){
      if (!mounted) return;
      Navigator.of(context).pop();
      DialogUtils.showMessageDialog(context: context, content: e.message ?? e.code);
    }catch(e){
      if (!mounted) return;
      Navigator.of(context).pop();
      DialogUtils.showMessageDialog(context: context, content: "Error: $e");
    }
  }
  signUpWithGoogle()async{
    try {
      DialogUtils.showLoadingDialog(context);
      await AuthService.signInWithGoogle();
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(RoutesManager.home);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      DialogUtils.showMessageDialog(context: context, content: 'Google sign up failed: $e');
    }
  }
}
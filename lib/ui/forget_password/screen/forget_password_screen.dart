import 'package:evently_c20/core/resources/app_constants.dart';
import 'package:evently_c20/core/reusable_components/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/reusable_components/custom_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController emailController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Check your email to reset your password")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: primary, size: 20,),
        ),
        title: Text("Forget Password",style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(AssetsManager.forgetPass,color: Theme.of(context).colorScheme.onPrimary,),
                SizedBox(height: 24,),
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
                SizedBox(height: 24,),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(title: "Reset password", onClick: () {
                    resetPassword();
                  },),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

abstract class DialogUtils {

  static void showMessageDialog(
      {
        required BuildContext context,
        required String content,
      }
      ){
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Warning"),
        content: Text(content, style: TextStyle(color: Colors.black87, fontSize: 14),) ,
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Ok"))
        ],
      ),);
  }

  static void showLoadingDialog(BuildContext context){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Loading...", style: TextStyle(color: Colors.black87),),
              SizedBox(width: 16,),
              Center(child: CircularProgressIndicator(),)
            ],
          ),
        ],
      ),
    ),);
  }
}
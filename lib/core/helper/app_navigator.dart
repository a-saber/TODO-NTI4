import 'package:flutter/material.dart';

abstract class AppNavigator {
  static void goTo(context, Widget distination, {bool replaceAll = false})
  {
    if(replaceAll){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> distination), (route) => false);
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => distination));
    }
  }
}
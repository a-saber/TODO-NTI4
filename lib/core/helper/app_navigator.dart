import 'package:flutter/material.dart';

abstract class AppNavigator {
  static Future<T?> goTo<T>(context, Widget distination, {bool replaceAll = false})async
  {
    if(replaceAll){
      return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> distination), (route) => false);
    }
    else{
      return await Navigator.push(context, MaterialPageRoute(builder: (context) => distination));
    }
  }
}
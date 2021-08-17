import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
class Utility
{
static String base64String(Uint8List data) {
return base64Encode(data);
}
static Image imageFromBase64String(String base64string)
{
return Image.memory(base64Decode(base64string),fit: BoxFit.fill);
}
}
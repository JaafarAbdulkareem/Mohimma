import 'package:flutter/material.dart';

extension ScaffoldExtension on Scaffold {
  Widget scaffoldArea() => SafeArea(child: this);
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';


class EnterExitRoute extends PageRouteBuilder {
  final Widget enter;
  final Widget exit;
  final Offset enterOffset;
  final Offset exitOffset;
  final Duration time;

  EnterExitRoute({
    required this.exit,
    required this.enter,
    this.enterOffset = const Offset(1.0, 0.0),
    this.exitOffset = const Offset(-1.0, 0.0),
    this.time = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enter,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: exitOffset,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: exit,
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: enterOffset,
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: enter,
              )
            ],
          ),
          transitionDuration: time,
        );
}

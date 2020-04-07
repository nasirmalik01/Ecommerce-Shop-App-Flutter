import 'package:flutter/material.dart';

//For animating specific routes or screens ... in specific places where we want to go to any other page
//called in AppDrawer Screen
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// For animating all the routes or screens... In Main Class
class CustomTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if(route.settings.isInitialRoute){
      return child;
    }
    return FadeTransition(opacity: animation, child: child,);
  }
}

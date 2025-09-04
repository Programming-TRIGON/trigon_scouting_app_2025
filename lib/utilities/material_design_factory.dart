import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/authentication/authentication_handler.dart';
import 'package:trigon_scouting_app_2025/authentication/user_data_provider.dart';
import 'package:trigon_scouting_app_2025/utilities/firebase_handler.dart';

class MaterialDesignFactory {
  static Widget createLoadingPage(String label) {
    return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 20),),
                const SizedBox(height: 20,),
                const CircularProgressIndicator()
              ]
          ),
        )
    );
  }

  static AppBar createAppBar(
    BuildContext context,
    Color color,
    String? title,
    String? subtitle,
  ) {
    final userDataProvider = context.watch<UserDataProvider>();

    return AppBar(
      toolbarHeight: 56,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'TRIGON Scouting App',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (subtitle != null)
            Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      actions: [
        PopupMenuButton<String>(
          enabled: userDataProvider.user != null,
          tooltip: 'Account Settings',
          onSelected: (value) async {
            if (value == 'logout') {
              userDataProvider.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                createModernRoute(const AuthenticationHandler()),
                (route) => false,
              );
            } else if (value == 'reset') {
              FirebaseHandler.resetPassword(context: context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
            const PopupMenuItem(value: 'reset', child: Text('Reset Password')),
          ],
          child: Row(
            children: [
              const Icon(Icons.person),
              if (userDataProvider.user?.displayName != null)
                Text(
                  userDataProvider.user!.displayName!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
            ],
          ),
        ),
      ],
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
    );
  }

  static Route createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // from right to left
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Route createNoAnimationRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  static Route createModernRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.025, 0.01), // ultra subtle
              end: Offset.zero,
            ).animate(curved),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.99, end: 1.0).animate(curved),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

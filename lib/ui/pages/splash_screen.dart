import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkstep/models/user.dart';
import 'package:inkstep/ui/components/gentle_loader.dart';
import 'package:inkstep/ui/pages/home_screen.dart';
import 'package:inkstep/ui/pages/welcome_back_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  AuthResult _auth;
  String _name;

  bool _shouldHoldSplash = true;

  // Load everything needed globally before the app starts
  @override
  void initState() {
    super.initState();

    Future<dynamic>.delayed(
      const Duration(seconds: 2),
      () => setState(() => _shouldHoldSplash = false),
    );

    // Load other async data here
    User.getName().then((name) => setState(() => _name = name));
    FirebaseAuth.instance.signInAnonymously().then((user) => setState(() => _auth = user));
  }

  // TODO(mm): should display SCM in centre as splash, animate up into app bar then either welcome
  // TODO(mm):   back <NAME> or enter name screen.


  // Display splash screen while loading, before displaying the home screen
  @override
  Widget build(BuildContext context) {
    // TODO(mm): proper security rules for firebase
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('journeys')
          .where('auth_uid', isEqualTo: _auth == null ? '-1' : _auth.user.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Display splash screen for a minimum of k seconds
        if (_shouldHoldSplash) {
          return WelcomeBackScreen(name: _name, loading: false);
        }

        return GentleLoader(
          loaded: HomeScreen(journeys: snapshot.data.documents),
          loading: WelcomeBackScreen(name: _name, loading: true),
          loadConditions: [_auth != null, snapshot.hasData],
        );
      },
    );
  }
}

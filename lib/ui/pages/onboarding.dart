import 'package:flutter/material.dart';
import 'package:inkstep/main.dart';
import 'package:inkstep/ui/components/default_flow_button.dart';
import 'package:inkstep/ui/components/logo.dart';
import 'package:inkstep/ui/components/user_flow_button.dart';
import 'package:inkstep/ui/pages/info_gathering.dart';
import 'package:inkstep/ui/pages/journey_page.dart';

class Onboarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  Widget _sub(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.grey,
          fontSize: 25.0,
          fontFamily: 'Signika',
          fontWeight: FontWeight.w100),
    );
  }

  Widget _header(String text) {
    return Text(
      text,
      style: TextStyle(
          color: baseColors['light'],
          fontSize: 40.0,
          fontFamily: 'Signika',
          fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Logo(),
            _header('Hi there,'),
            _header("We're here to help"),
            Padding(
              padding: const EdgeInsets.only(top: 64.0),
            ),
            _sub('Every step'),
            _sub('of the way'),
          ],
        ),
      ),
    );

    final bottom = Container(
      child: Column(
        children: <Widget>[
          BoldCallToAction(destination: InfoScreen()),
          Padding(padding: EdgeInsets.only(top: 32.0)),
          UserFlowButton(destination: JourneyPage()),
        ],
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          top,
          Padding(padding: EdgeInsets.only(top: 275.0)),
          bottom
        ],
      ),
      backgroundColor: baseColors['dark'],
    );
  }
}
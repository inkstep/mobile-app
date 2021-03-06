import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkstep/models/artist.dart';
import 'package:inkstep/models/card.dart';
import 'package:inkstep/ui/pages/artists_screen.dart';
import 'package:inkstep/ui/pages/care_screen.dart';
import 'package:inkstep/ui/pages/confirm_artist_screen.dart';
import 'package:inkstep/ui/pages/journey_messages_screen.dart';
import 'package:inkstep/ui/pages/journeys_screen.dart';
import 'package:inkstep/ui/pages/new/login_screen.dart';
import 'package:inkstep/ui/pages/onboarding.dart';
import 'package:inkstep/ui/pages/onboarding_required_info.dart';
import 'package:inkstep/ui/pages/single_artist_screen.dart';
import 'package:inkstep/ui/pages/single_journey_screen.dart';
import 'package:inkstep/ui/pages/splash_screen.dart';
import 'package:inkstep/ui/routes/fade_page_route.dart';
import 'package:inkstep/ui/routes/scale_page_route.dart';

import '../main.dart';
import 'info_navigator.dart';

class ScreenNavigator {
  void pop(BuildContext context) {
    Navigator.pop(context);
  }

  void restartApp(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => Inkstep()),
      (Route<dynamic> route) => false,
    );
  }

  void openOnboardingPage(BuildContext context) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => Onboarding()),
    );
  }

  void openOnboardingRequiredInfoPage(BuildContext context) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => OnboardingRequiredInfo(),
        fullscreenDialog: true,
      ),
    );
  }

  void openHomeScreen(BuildContext context) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => SplashScreen()),
    );
  }

  void openLoginScreen(BuildContext context) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => LoginScreen()),
    );
  }

  void openViewJourneysScreenWithNewDevice(BuildContext context, int userId) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => JourneysScreen()),
    );
  }

  void expandArtistSelection(BuildContext context, RelativeRect rect) {
    Navigator.push<dynamic>(
      context,
      ScaleRoute(
        rect: rect,
        child: ArtistSelectionScreen(),
      ),
    );
  }

  void openNewJourneyScreen(BuildContext context, int artistId) {
    InfoNavigator(artistId).start(context);
  }

  void openCareScreen(BuildContext context, DateTime bookedTime) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => CareScreen(bookedTime: bookedTime),
        fullscreenDialog: true,
      ),
    );
  }

  void openFullscreenJourney(BuildContext context, CardModel card) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => SingleJourneyScreen(card: card),
        fullscreenDialog: true,
      ),
    );
  }

  void openJourneyMessagesScreen(BuildContext context, CardModel card) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => JourneyMessagesScreen(card: card),
        fullscreenDialog: true,
      ),
    );
  }

  void openSingleArtistScreen(BuildContext context, Artist artist) {
    Navigator.push<dynamic>(
      context,
      FadeRoute(
        page: SingleArtistScreen(artist: artist),
        fullscreen: true,
      ),
    );
  }

  void openArtistConfirmScreen(BuildContext context, Artist artist) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => ConfirmArtistScreen(artist: artist)),
    );
  }
}

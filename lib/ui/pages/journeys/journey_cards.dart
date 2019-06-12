import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkstep/blocs/journeys_bloc.dart';
import 'package:inkstep/blocs/journeys_event.dart';
import 'package:inkstep/di/service_locator.dart';
import 'package:inkstep/models/card_model.dart';
import 'package:inkstep/models/journey_stage.dart';
import 'package:inkstep/ui/components/progress_indicator.dart';
import 'package:inkstep/ui/pages/journeys/described_icon.dart';
import 'package:inkstep/ui/pages/journeys/image_snippet.dart';
import 'package:inkstep/ui/pages/journeys/stage_dialogs.dart';
import 'package:inkstep/utils/screen_navigator.dart';

class JourneyCard extends StatefulWidget {
  const JourneyCard({Key key, @required this.model, this.scale}) : super(key: key);

  final Future<CardModel> model;
  final double scale;

  @override
  _JourneyCardState createState() => _JourneyCardState();
}

class _JourneyCardState extends State<JourneyCard> with SingleTickerProviderStateMixin {
  Animation<double> loopedAnimation;
  AnimationController loopController;

  @override
  void initState() {
    super.initState();
    loopController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    loopedAnimation = CurvedAnimation(parent: loopController, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          loopController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          loopController.forward();
        }
        // Mark widget as dirty
        setState(() {});
      });
    loopController.forward();
  }

  @override
  void dispose() {
    loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CardModel>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<CardModel> snapshot) {
        return GestureDetector(
          onTap: () {
            final JourneysBloc journeyBloc = BlocProvider.of<JourneysBloc>(context);
            journeyBloc.dispatch(LoadJourneys());
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: (snapshot.hasData && snapshot.data != null)
                ? LoadedJourneyCard(
                    card: snapshot.data,
                    animation: loopedAnimation,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).backgroundColor),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class LoadedJourneyCard extends AnimatedWidget {
  const LoadedJourneyCard({
    Key key,
    @required this.card,
    @required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  final CardModel card;

  static final _elevationTween = Tween<double>(begin: 0, end: 20);

  @override
  Widget build(BuildContext context) {
    final Animation<double> progression = listenable;
    final Color accentColor = card.palette.vibrantColor?.color ?? Theme.of(context).accentColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Widget dialog;
                  if (card.stage is QuoteReceived) {
                    dialog = QuoteDialog(
                      stage: card.stage,
                      artistName: card.artistName,
                      onAcceptance: () {
                        final JourneysBloc journeyBloc = BlocProvider.of<JourneysBloc>(context);
                        journeyBloc.dispatch(QuoteAccepted(card.journeyId));
                        final ScreenNavigator nav = sl.get<ScreenNavigator>();
                        nav.pop(context);
                      },
                      onDenial: () {
                        print('Quote denial');
                        final ScreenNavigator nav = sl.get<ScreenNavigator>();
                        nav.pop(context);
                      },
                    );
                  } else if (card.stage is AppointmentOfferReceived) {
                    dialog = DateDialog(
                      stage: card.stage,
                      artistName: card.artistName,
                      onAcceptance: () {
                        print('Date acceptance');
                        final ScreenNavigator nav = sl.get<ScreenNavigator>();
                        nav.pop(context);
                      },
                      onDenial: () {
                        print('Date denial');
                        final ScreenNavigator nav = sl.get<ScreenNavigator>();
                        nav.pop(context);
                      },
                    );
                  }
                  if (dialog != null) {
                    showGeneralDialog<void>(
                      barrierColor: Colors.black.withOpacity(0.4),
                      transitionBuilder: (context, a1, a2, widget) {
                        return Transform.translate(
                          offset: Offset.fromDirection(0, a1.value),
                          child: Opacity(
                            opacity: a1.value,
                            child: dialog,
                          ),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      pageBuilder: (context, animation1, animation2) {},
                    );
                  }
                },
                child: Chip(
                  label: Text(card.stage.toString()),
                  backgroundColor: accentColor,
                  shadowColor: accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation:
                      card.stage.userActionRequired ? _elevationTween.evaluate(progression) : 0.0,
                ),
              ),
              Spacer(),
              DescribedIconButton(
                icon: Icons.healing,
                featureId: card.aftercareID,
                onPressed: () {
                  final ScreenNavigator nav = sl.get<ScreenNavigator>();
                  nav.openAftercareScreen(context);
                },
              ),
            ],
          ),
        ),
        ImageSnippet(
          images: card.images,
          axis: Axis.horizontal,
        ),
        Spacer(
          flex: 8,
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Chip(
            avatar: CircleAvatar(
              backgroundImage: AssetImage('assets/ricky.png'),
              backgroundColor: Colors.transparent,
            ),
            label: Text(
              card.artistName,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Text(
            '${card.description}',
            style: Theme.of(context).accentTextTheme.title.copyWith(
                  color: accentColor,
                ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 32.0, bottom: 16.0),
          child: JourneyProgressIndicator(
            color: accentColor,
            progress: card.stage.progress,
            style: Theme.of(context).accentTextTheme.caption,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inkstep/blocs/journeys_bloc.dart';
import 'package:inkstep/blocs/journeys_event.dart';
import 'package:inkstep/blocs/journeys_state.dart';
import 'package:inkstep/di/service_locator.dart';
import 'package:inkstep/ui/components/journey_cards.dart';
import 'package:inkstep/ui/pages/onboarding/welcome_back_header.dart';
import 'package:inkstep/utils/screen_navigator.dart';

class JourneysScreen extends StatefulWidget {
  const JourneysScreen({Key key, this.onInit}) : super(key: key);

  @override
  _JourneysScreenState createState() => _JourneysScreenState();

  final void Function() onInit;
}

class _JourneysScreenState extends State<JourneysScreen> with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;

  AnimationController _controller;
  Animation<double> _animation;
  PageController _pageController;

  @override
  void initState() {
    widget.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final JourneysBloc journeyBloc = BlocProvider.of<JourneysBloc>(context);
    return BlocBuilder<JourneysEvent, JourneysState>(
      bloc: journeyBloc,
      builder: (BuildContext context, JourneysState state) {
        if (state is JourneyError) {
          print('JourneyError');
          Navigator.pop(context);
        }

        if (state is JourneysNoUser) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        } else if (state is JourneysWithUser) {
          final JourneysWithUser loadedState = state;
          _controller.forward();

          final FloatingActionButton addJourneyButton = state.cards.isEmpty
              ? null
              : FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final nav = sl.get<ScreenNavigator>();
                    nav.openArtistSelection(context);
                  },
                );

          return Scaffold(
            floatingActionButton: addJourneyButton,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              title: Text(''),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: FadeTransition(
              opacity: _animation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  WelcomeBackHeader(
                    // TODO(DJRHails): Use a user bloc
                    name: loadedState.cards.isEmpty ? '' : loadedState.user.name,
                    tasksToComplete: 0,
                  ),
                  Expanded(
                    flex: 1,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          final currentPage = _pageController.page.round().toInt();
                          if (_currentPageIndex != currentPage) {
                            setState(() => _currentPageIndex = currentPage);
                          }
                        }
                      },
                      child: PageView.builder(
                        controller: _pageController,
                        itemBuilder: (BuildContext context, int index) {
                          if (state.cards.isEmpty) {
                            return AddCard();
                          } else {
                            return JourneyCard(model: state.cards[index]);
                          }
                        },
                        itemCount: state.cards.isEmpty ? 1 : state.cards.length,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 32.0),
                  ),
                ],
              ),
            ),
          );
        } else {
          print(state);
          return Container(
            child: Center(child: Text('Abort Mission')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

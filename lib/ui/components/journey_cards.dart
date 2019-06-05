import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkstep/di/service_locator.dart';
import 'package:inkstep/models/card_model.dart';
import 'package:inkstep/utils/screen_navigator.dart';

class AddCard extends StatelessWidget {
  const AddCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).backgroundColor;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            final nav = sl.get<ScreenNavigator>();
            nav.openArtistSelection(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 52.0,
                  color: textColor,
                ),
                Container(
                  height: 8.0,
                ),
                Text(
                  'Start a new journey',
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JourneyCard extends StatelessWidget {
  const JourneyCard({Key key, @required this.model}) : super(key: key);

  final CardModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('Existing card tapped');
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(
                  flex: 8,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  // TODO(DJRHails): Should be Hero-d
                  child: Text(
                    '${model.artistName}',
                    style: Theme.of(context).accentTextTheme.body1,
                  ),
                ),
                Container(
                  // TODO(DJRHails): Should be Hero-d
                  child:
                      Text('${model.description}', style: Theme.of(context).accentTextTheme.title),
                ),
                Spacer(),
                RaisedButton(
                  onPressed: () {
                    final ScreenNavigator nav = sl.get();
                    nav.openAftercareScreen(context);},
                  elevation: 15.0,
                  padding: EdgeInsets.fromLTRB(
                      32.0, 16.0, 32.0, 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text('Aftercare Information', style: TextStyle(
                      fontSize: 20.0, fontFamily: 'Signika'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

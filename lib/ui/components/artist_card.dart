import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkstep/di/service_locator.dart';
import 'package:inkstep/models/artist.dart';
import 'package:inkstep/theme.dart';
import 'package:inkstep/ui/components/scale_on_tap.dart';
import 'package:inkstep/utils/screen_navigator.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard(this.artist, {Key key}) : super(key: key);

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      onTap: () {
        final ScreenNavigator nav = sl.get<ScreenNavigator>();
        nav.openSingleArtistScreen(context, artist);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: artist,
            child: Card(
              color: Colors.black,
              clipBehavior: Clip.antiAlias,
              // TODO(mm): must be a better way than this container
              child: Container(
                height: 200,
                width: 100000,
                child: artist.profileImage,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: smallBorderRadius,
              ),
              elevation: 10,
              margin: EdgeInsets.all(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              artist.name.toUpperCase(),
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}

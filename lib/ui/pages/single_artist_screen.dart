import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inkstep/models/artist.dart';
import 'package:inkstep/ui/components/platform_switch.dart';

import '../../theme.dart';

class SingleArtistScreen extends StatelessWidget {
  const SingleArtistScreen({Key key, this.artist}) : super(key: key);

  final Artist artist;

  // Update whether or not this user should get notifications for this artist
  Future<void> updateSubscriptions(bool subscribe, String uid) async {
    // Get current artist subscriptions
    final QuerySnapshot subs = await Firestore.instance
        .collection('artist_subs')
        .where('auth_uid', isEqualTo: uid)
        .getDocuments();

    if (subs.documents.isEmpty) {
      final List<int> subscriptions = subscribe ? [artist.artistId] : [];
      Firestore.instance
          .collection('artist_subs')
          .add(<String, dynamic>{'auth_uid': uid, 'artistIds': subscriptions});
    } else {
      final List<dynamic> existing = subs.documents[0].data['artistIds'];
      final List<int> subscriptions = [];
      existing.forEach(subscriptions.add);

      if (subscribe) {
        // Add to list if not already there
        if (!subscriptions.contains(artist.artistId)) {
          subscriptions.add(artist.artistId);
        }
      } else {
        // Remove from list if there
        subscriptions.removeWhere((dynamic id) => id == artist.artistId);
      }

      // Update existing doc
      Firestore.instance
          .collection('artist_subs')
          .document(subs.documents[0].documentID)
          .updateData(<String, dynamic>{'artistIds': subscriptions});
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle body = Theme.of(context).textTheme.body2;
    final TextStyle subheading = Theme.of(context).textTheme.subhead;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          artist.name.toUpperCase(),
          style: Theme.of(context).textTheme.headline.copyWith(fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 40,
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(
//          Icons.keyboard_arrow_right,
//          color: Colors.white,
//        ),
//        backgroundColor: Theme.of(context).accentColor,
//        onPressed: () {
//          final ScreenNavigator nav = sl.get<ScreenNavigator>();
//          nav.openArtistConfirmScreen(context, artist);
//        },
//      ),
      backgroundColor: Color.fromRGBO(40, 40, 40, 1.0), // Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: <Widget>[
            Hero(
              tag: artist,
              child: Card(
                child: artist.profileImage,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: largeBorderRadius,
                ),
                elevation: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:
                        Text('Ricky Williams opened up South City Market in 2019...', style: body),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text('Style', style: subheading),
                  ),
                  Text('Ricky\'s main styles are...', style: body),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text('Subscribe to updates', style: subheading),
                  ),

                  // TODO(mm): messy, need to use persistent state model to get this stuff
                  FutureBuilder(
                    future: FirebaseAuth.instance.signInAnonymously(),
                    builder: (BuildContext context, AsyncSnapshot auth) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('artist_subs')
                            .where('auth_uid', isEqualTo: auth.hasData ? auth.data.user.uid : '-1')
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            // Check if subscribed to this artist, check first doc only
                            final List<dynamic> ids = snapshot.data.documents[0].data['artistIds'];
                            return PlatformSwitch(
                              initialValue: ids.contains(artist.artistId),
                              callback: (value) => updateSubscriptions(value, auth.data.user.uid),
                            );
                          }
                          return SpinKitChasingDots(
                            color: Theme.of(context).cardColor,
                            size: 50.0,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

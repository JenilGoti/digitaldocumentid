import 'dart:math';

import 'package:digitaldocumentid/screens/all_document_list_screen/all_document_screen.dart';
import 'package:digitaldocumentid/screens/download_List/download_list_screen.dart';
import 'package:digitaldocumentid/screens/edit_user_detail_screen.dart';
import 'package:digitaldocumentid/screens/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class DrowerWidget extends StatelessWidget {
  DrowerWidget({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.7,
            height: max(MediaQuery.of(context).size.height * 0.30, 250),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      _auth.currentUser!.photoURL.toString(),
                    ),
                    maxRadius: 45,
                    minRadius: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _auth.currentUser!.displayName
                                .toString()
                                .toUpperCase(),
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('E-mail: ${_auth.currentUser!.email.toString()}',
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              'Mob. No. : ${_auth.currentUser!.phoneNumber.toString()}',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditUserDetailScreen(),
                            ));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          buildListTile(context,'Home',const HomePage(),Icons.home),
          const Divider(),
          buildListTile(context,'Add Documents',AllDocumentListScreen(),Icons.add_card_rounded),
          const Divider(),
          buildListTile(context,'Downloads',DownLoadList(),Icons.download_rounded),
          const Divider(),
          ListTile(
            focusColor: Theme.of(context).primaryColorLight,
            style: ListTileStyle.drawer,
            hoverColor: Theme.of(context).primaryColorLight,
            title: Text('Log out'),
            onTap: () async{
              await FirebaseAuth.instance.signOut();
              Phoenix.rebirth(context);

            },
            trailing: Icon(Icons.logout),
          ),
          const Divider(),
        ],
      ),
    );
  }

  ListTile buildListTile(BuildContext context,title,screen,icon) {
    return ListTile(
          focusColor: Theme.of(context).primaryColorLight,
          style: ListTileStyle.drawer,
          hoverColor: Theme.of(context).primaryColorLight,
          title: Text(title),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => screen,
            ));
          },
          trailing:Icon(icon),
        );
  }
}

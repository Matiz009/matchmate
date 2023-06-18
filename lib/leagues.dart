import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchmate/teams.dart';
//import 'Teams.dart';

import 'colors.dart' as colors;

class Leagues extends StatefulWidget {
  const Leagues({Key? key}) : super(key: key);

  @override
  State<Leagues> createState() => _LeaguesState();
}

class _LeaguesState extends State<Leagues> {
  final CollectionReference _leagues =
  FirebaseFirestore.instance.collection('Leagues');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _leagues.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final leagues = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leagues.length,
              itemBuilder: (BuildContext context, int index) {
                final league = leagues[index];

                final data = league.data() as Map<String, dynamic>;
                final id = data['league_id'];

                return GestureDetector(
                  onTap: () {
                    String leagueId = id;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Teams(LeagueId: id),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.blueAccent.withOpacity(0.7),
                              Colors.white60.withOpacity(0.9),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.centerRight
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          topRight: Radius.circular(20),

                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(5,10),
                            blurRadius: 10,
                            color: colors.AppColor.gradientSecond.withOpacity(0.2),

                          )
                        ]
                    ),
                    child: ListTile(
                      title: Text(
                        textAlign:TextAlign.end,
                        ' ${data['league_name']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times New Roman',
                          fontSize: 14,

                        ),
                      ),
                      leading: Image.network(
                            '${data['league_url']}',
                          ),

                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

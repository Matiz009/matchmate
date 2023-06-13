import 'package:flutter/material.dart';
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

  final CollectionReference _leagues = FirebaseFirestore.instance.collection('Leagues');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _leagues.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final leagues = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leagues.length,
            itemBuilder: (BuildContext context, int index) {
              final league = leagues[index];
              final data = league.data() as Map<String, dynamic>;
              final id=data['league_id'];

              return GestureDetector(
                onTap: () {
                  String leagueId=id;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  Teams(League_id: leagueId,),
                    ),
                  );
                },
                child: Container(
                  width: 300, // Set a fixed width value
                  height: 100, // Set a fixed height value
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.7),
                        Colors.white60.withOpacity(0.9),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(5, 10),
                        blurRadius: 10,
                        color: colors.AppColor.gradientSecond.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        '${data['league_url']}',
                        width: 50,
                        height: 50,
                      ),
                      Expanded(child: Container()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,

                      ),
                    ],
                  ),
                )
              );
            },
          );
        },

      ),
    );
  }
}

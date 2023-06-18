import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchmate/channels.dart';
import 'colors.dart' as colors;

class Matches extends StatefulWidget {
  const Matches({Key? key}) : super(key: key);

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  final CollectionReference _matches = FirebaseFirestore.instance.collection('matches');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Padding(
          padding: EdgeInsets.only(right: 30),
          child: Center(child: Text('Matches')),
        ),
        backgroundColor: colors.AppColor.homePageIcons,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _matches.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final matches = snapshot.data!.docs;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (BuildContext context, int index) {
              final match = matches[index];
              final id = match.id;
              final data = match.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Channels(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: colors.AppColor.homePageContainerTextBig,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(data["team_1_name"],textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          const Expanded(child: Text('vs',textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold
                            ),
                          )),
                          Text(data["team_2_name"],textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3,),
                      Text("Date:"+data["match_date"],textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )
                ),
              );
            },
          );
        },

      ),
    );
  }
}
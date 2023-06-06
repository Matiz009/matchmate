import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'Teams.dart';
import 'colors.dart' as colors;

class Teams extends StatefulWidget {
  const Teams({Key? key}) : super(key: key);

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final CollectionReference _teams = FirebaseFirestore.instance.collection('Teams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Teams')),
        backgroundColor: colors.AppColor.homePageIcons,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _teams.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final teams = snapshot.data!.docs;

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) {
              final team = teams[index];
              final id = team.id;
              final data = team.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {

                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: colors.AppColor.homePageContainerTextBig,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ListTile(
                    title: Text('ID: ${data['league_id']}, Name: ${data['team_name']}',style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                      fontSize: 14,
                    ),),
                    leading:  ClipOval(
                      child: Image.network(
                        '${data['team_url']}',
                        width: 200,
                        height: 220,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },

      ),
    );
  }
}

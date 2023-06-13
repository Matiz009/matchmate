import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchmate/channels.dart';
import 'colors.dart' as colors;

class Teams extends StatefulWidget {
  final String League_id;
  const Teams({required this.League_id,Key? key}) : super(key: key);

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
 // final CollectionReference _teams = FirebaseFirestore.instance.collection('Teams');
  late Stream<QuerySnapshot> fireStore;
  late String id;


  void refreshData(String id) {
    setState(() {
      this.id = id;
      fireStore = FirebaseFirestore.instance
          .collection('Teams')
          .where('league_id', isEqualTo: id)
          .snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    id = widget.League_id;
    fireStore = FirebaseFirestore.instance
        .collection('Teams')
        .where('league_id', isEqualTo: id)
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Padding(
          padding: EdgeInsets.only(right: 30),
          child: Center(child: Text('Teams')),
        ),
        backgroundColor: colors.AppColor.homePageIcons,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore,
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
              final data = team.data() as Map<String, dynamic>;

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
                  child: ListTile(
                    title: Text('Name: ${data['team_name']}',style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Verdana',
                      fontSize: 12,
                    ),),
                    leading:  ClipOval(
                      child: Image.network(
                        '${data['team_url']}',
                        width: 220,
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

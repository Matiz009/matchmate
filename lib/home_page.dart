import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'colors.dart' as color;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
    body: Container(
      padding: const EdgeInsets.only(top: 80,left: 30,right: 30),
        child: Column(
        children: [
          Row(
            children: [
              Text('Match Mate',
                style:TextStyle(
                  fontSize: 30,
                  color: color.AppColor.homePageTitle,
                  fontWeight: FontWeight.w700
                ),)
            ],
          ),
        ],
    ),
    ),
    );
  }
}

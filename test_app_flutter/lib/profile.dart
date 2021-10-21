import 'package:flutter/material.dart';
import 'package:test_app/service/service.dart';
import 'package:test_app/utils/storage.dart';

import 'models/user.dart';


class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> { 

  late String name;
  late String email;
  late String realPassword;
  late String adress;
  late String type; 
  late String token; 
  late int id; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() async {
    String access_token = await Storage.getStringValue('access_token');
    Map<String, dynamic> userinfo = await Storage.getStringValue('user_details');
    User user = User.fromJson(userinfo);

    setState(() {
      name = user.name;
      email = user.email;
      realPassword = user.real_password;
      adress = user.adresse;
      type = user.type;
      token = access_token;
      id = user.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nom"),
                  Text(name)
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("adresse"),
                  Text(adress)
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("email"),
                  Text(email)
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("type"),
                  Text(type)
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Password"),
                  Text(realPassword)
                ],
              ),
            ),

            type == '' ? InkWell(
              onTap: () async {
                AllService a = new AllService();
                var as =  await a.getGameData(id, token);
              }, 
              child: Container(
                height: 80,
                width: 180,
                child: Text('Mes entreprise'),
              ),
            ) : Container(),
          ],
        ),
      )
    );
  }
}
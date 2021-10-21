
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/utils/storage.dart';

import 'profile.dart';  

 
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); 
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isHidden = true;
  String error = ''; 
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async{ 
    String access_token = await Storage.getStringValue('access_token');
    if(access_token != ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Profile()), (Route<dynamic> route)=> false);
    }
      
  }

  void _triggerVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, 
      appBar: AppBar(
        backgroundColor: Colors.amber,
        iconTheme: new IconThemeData(color: Color(0xFFFFFFFF)),
        title: Text('Login', style: TextStyle(color: Colors.white, ),),
      ), 
      body:  _isLoading ? Center(child: CircularProgressIndicator(),) :  Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  
                ),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            alignment: Alignment.topCenter, 
                        )),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(error, 
                          textAlign: TextAlign.center,
                           style: TextStyle(
                            color: Colors.red, 
                            fontSize: 15, fontWeight: 
                            FontWeight.bold),)
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'email',
                                    icon: Icon(Icons.alternate_email), 
                                ),
                                /**/ validator: (value) {
                                if (value!.isEmpty) {
                                  String pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value)) 
                                    return 'Email invalid';
                                  else
                                    return null;
                                }
                                return null;
                              },
                                keyboardType: TextInputType.emailAddress, 
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Mot de passe",
                                    icon: Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: _triggerVisibility,
                                      icon: _isHidden
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                    )),

                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Saisez le mot de passe';
                                  } else if (value.length < 6) {
                                    return "Mot de passe trop court";
                                  }
                                  return null;
                                },
                                obscureText: _isHidden ? _isHidden : false,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.amber,
                              elevation: 0.0,
                              child: MaterialButton( //async
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);

                                    Object userData = { 
                                  "email": emailController.text,
                                  "password": passwordController.text, 
                                }; 
                                http.Response response = await http.post(
                                                              Uri.parse('https://thawing-inlet-32337.herokuapp.com/api/auth/login'),
                                                              headers: <String, String>{
                                                                'Content-Type': 'application/json; charset=UTF-8',
                                                                "Accept": "application/json"
                                                              },
                                                              body: jsonEncode(userData),
                                                            ); 
 
 
                                      final jsonResponse = json.decode(response.body) ;
 
                                      if(jsonResponse["error"] == "Unauthorized"){
                                        setState(() {
                                          _isLoading = false;
                                          error = 'Identfiant incorect';
                                        });
                                      }else if(jsonResponse["access_token"] != ''){
                                        setState(() { _isLoading = false; }); 
                                        
                                        
                                        Storage.setString("access_token", jsonResponse['access_token']);
                                        Storage.setString("user_details", jsonResponse.data.user);
                                          
                                        setState(() { 
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Profile()), (Route<dynamic> route)=> false);

                                        });
                                      }else{
                                        setState(() {
                                          _isLoading = false;
                                          error = "Erreur de chargement";
                                        });

                                      }  

                                  }
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text('Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )),
                        ), 
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
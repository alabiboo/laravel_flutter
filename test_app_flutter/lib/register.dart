
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:async';

import '../main.dart';
import 'login.dart';
import 'models/user.dart';
import 'utils/storage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
 
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmationController = new TextEditingController();
  TextEditingController adressController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController emailController = new TextEditingController(); 


  List<String> paysSLists = ['pro', 'private'];
  static List<String> _dropdownItems = [];
  late String _dropdownValue;

  bool _isLoading = false;
  bool _isHidden = true;
  bool _isConfHidden = true;
 
  late String _errorText;
  late String errorsms; 

  @override
  void initState() {
    super.initState();

  }

  void _triggerVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _triggerConfVisibility() {
    setState(() {
      _isConfHidden = !_isConfHidden;
    });
  }





  @override
  Widget build(BuildContext context) { 

    return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: Text(
                'Créaton de compte',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: new IconThemeData(color: Colors.white),
            ),
            body:  _isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.amber,))
        : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Form(
                key: _formKey,
                child: ListView( 
                  children: <Widget>[
// name field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            controller: nameController, 
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nom',  ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Le nom est obligatoir';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            controller: typeController,
                            decoration: InputDecoration(
                              border: InputBorder.none, 
                              hintText: 'Type', 
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Type est obligatoir';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: adressController,
                            decoration: InputDecoration(
                              border: InputBorder.none, 
                              hintText: 'adresse',
                              icon: Icon(Icons.phone_android),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'adress est obligatoir';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
//email field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
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
                                hintText: 'Email',
                                icon: Icon(Icons.alternate_email), ),
                            /**/ validator: (value) {
                              if (value!.isEmpty) {
                                String pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Address mail invalide';
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
// password field

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
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
                                hintText: 'Mot de passe',
                                icon: Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: _triggerVisibility,
                                  icon: _isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Mot de passe obligator';
                              } else if (value.length < 6) {
                                return 'Mott de pass trop court';
                              }
                              return null;
                            },
                            obscureText: _isHidden ? _isHidden : false,
                          ),
                        ),
                      ),
                    ),

// password confirmation  field
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            controller: passwordConfirmationController,
                            decoration: InputDecoration(
                                border: InputBorder.none, 
                                hintText: 'Confirmation de mot de pass',
                                icon: Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: _triggerConfVisibility,
                                  icon: _isConfHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                //
                                return 'Confirmation de mot de passe obligatoir';
                              } else if (passwordConfirmationController.text !=
                                  passwordController.text) {
                                return 'les mot de passe non identique';
                              }
                              return null;
                            },
                            obscureText: _isConfHidden ? _isConfHidden : false,
                          ),
                        ),
                      ),
                    ),

                    // Tesr dropdow
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.amber,
                          elevation: 0.0,
                          child: MaterialButton(
                            //async
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isLoading = true);
                                Object userData = {
                                  "name": nameController.text,
                                  "type": typeController.text,
                                  "email": emailController.text,
                                  "adresse": adressController.text, 
                                  "password_confirmation": passwordConfirmationController.text,
                                  "password": passwordController.text, 
                                }; 
                                

                                http.Response response = await http.post(
                                                              Uri.parse('192.168.1.67/api/auth/register'),
                                                              headers: <String, String>{
                                                                'Content-Type': 'application/json; charset=UTF-8',
                                                                "Accept": "application/json"
                                                              },
                                                              body: jsonEncode(userData),
                                                            ); 
 
                                if (response.statusCode == 201) {

                                final jsonResponse = json.decode(response.body); 
                                  setState(() => _isLoading = false);
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route)=> false);
    
                                  
                                } 
                                else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showAlertDialog(
                                      context,
                                      'Erreur de chargement de donné');
                                } 
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text("S'enregistrer",
                              textAlign: TextAlign.center,
                              style: TextStyle( 
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Vous avez deja un compte ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, ),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
 
/*
  Widget _buildType() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey.withOpacity(0.2),
              elevation: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width, 
                  child: new InputDecorator(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintText: 'Choisi le type',
                      prefixIcon: Icon(Icons.location_on), 
                      errorText: _errorText,
                    ), 
                    isEmpty: _dropdownValue == '',
                    child: new DropdownButton<String>(
                      value: _dropdownValue,
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                          typeController.text = _dropdownValue; 
                        });
                      },
                      items: _dropdownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ), 
              ),
            ),
          ),
        );
      },
    );
  }*/
}



showAlertDialogLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogSuccess(BuildContext context, String message) {
  Widget cancelButton = FlatButton(
    //child: Text("Cancel"),
    child: Text("Ok"),
    onPressed: () {
      //Navigator.of(context).pop();

      Navigator.pop(context, true);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => MyApp()));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text(message),
    actions: [
      //remindButton,
      cancelButton,
      //launchButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(BuildContext context, String message) {
  // set up the buttons
  Widget remindButton = FlatButton(
    child: Text("Remind me later"),
    onPressed: () {},
  );
  Widget cancelButton = FlatButton(
    //child: Text("Cancel"),
    child: Text("Ok"),
    onPressed: () {
      //Navigator.of(context).pop();
      Navigator.pop(context, true);
    },
  );
  Widget launchButton = FlatButton(
    child: Text("Launch missile"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text(message),
    actions: [
      //remindButton,
      cancelButton,
      //launchButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
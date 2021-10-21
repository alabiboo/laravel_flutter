import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateEntreprise extends StatefulWidget {
  const CreateEntreprise({ Key? key }) : super(key: key);

  @override
  _CreateEntrepriseState createState() => _CreateEntrepriseState();
}

class _CreateEntrepriseState extends State<CreateEntreprise> {
  

  final _formKey = GlobalKey<FormState>();
  TextEditingController entreprisenameController = new TextEditingController();

  TextEditingController cfenumberController = new TextEditingController();

  bool _isLoading = false;
  late String error;
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Publicatioin"), backgroundColor: Colors.amber,),
      body: Container(
        child: Form(
                key: _formKey,
                child: ListView( 
                  children: <Widget>[ 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextFormField(
                            controller: entreprisenameController, 
                            decoration: InputDecoration(
                              
                                border: InputBorder.none,
                                hintText: "Nom de l'entreprise",  ),
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
                            controller: cfenumberController, 
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Numero du cfe",  ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Le numero cfe est obligatoire';
                              }
                              return null;
                            },
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
                                  "name_entreprise": entreprisenameController.text,
                                  "cfe_number": cfenumberController.text,
                                  "user_id": 1, 
                                }; 
                                http.Response response = await http.post(
                                                              Uri.parse('https://thawing-inlet-32337.herokuapp.com/api/'),
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
                                          error = 'Access non autorisé';
                                        });
                                      }else if(jsonResponse["access_token"] != ''){
                                        setState(() { _isLoading = false; }); 
                                         
                                      }else{
                                        setState(() {
                                          _isLoading = false;
                                          error = "Erreur de chargement";
                                        });

                                      }  

                                  }
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text('Créer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )),
                        ),
                  ])),
      ),
    );
  }
}
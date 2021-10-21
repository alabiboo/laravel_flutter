import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Post extends StatefulWidget {
  const Post({ Key? key }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {


  final _formKey = GlobalKey<FormState>();
  TextEditingController postController = new TextEditingController();

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
                            controller: postController, 
                            decoration: InputDecoration(
                              
                                border: InputBorder.none,
                                hintText: 'Contenu',  ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Le Cobtenu est obligatoir';
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
                                  "post_content": postController.text,
                                  "user_id": 1, 
                                }; 
                                http.Response response = await http.post(
                                                              Uri.parse('/api/'),
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
                                child: Text('Publier',
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
import 'package:flutter/material.dart';

import 'models/entreprise.dart';

class EntreprseList extends StatefulWidget {
  List<Entreprise> entrepriseList;

  EntreprseList({ Key? key,  required this.entrepriseList}) : super(key: key);

  @override
  _EntreprseListState createState() => _EntreprseListState();
}

class _EntreprseListState extends State<EntreprseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes entreprise'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.entrepriseList.length,
          itemBuilder: (_, index){
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.entrepriseList[index].entreprisename),
                  Text(widget.entrepriseList[index].cfenumber),
                ],
              ),
            );
          }
          ),
      ),
    );
  }
}
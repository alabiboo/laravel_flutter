class Entreprise {  
  String entreprisename; 
  String cfenumber;
  int id;

  factory Entreprise.fromJson(Map<String, dynamic> data) {  
    return  new Entreprise(
      id: data['id'],
      entreprisename: data['name_entreprise'],
      cfenumber: data['cfe_number'], 
    );
  }


  Entreprise({
    required this.id,
    required this.entreprisename,
    required this.cfenumber, 
  });

}
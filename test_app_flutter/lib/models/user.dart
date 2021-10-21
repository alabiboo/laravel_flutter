
class User {
  int id; 
  String name; 
  String email;
  String type; 
  String adresse;  
  String real_password;  

  factory User.fromJson(Map<String, dynamic> data) {  
    return  new User(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      adresse: data['adresse'],
      real_password: data['real_password'],
      type : data['type'], 
    );
  }

  User({
    required this.name,
    required this.id,
    required this.email,
    required this.adresse, 
    required this.real_password,
    required this.type, 
  });
 

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'adresse': adresse, 
      'real_password': real_password,
      'type': type, 
    };
  }

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write('User: {');
    sb.write('id: $id, ');
    sb.write('name: $name, '); 
    sb.write('email: $email, ');
    sb.write('adresse: $adresse, '); 
    sb.write('real_password: $real_password, ');
    sb.write('type: $type, ');   
    sb.write('}');
    return sb.toString();
  }
}

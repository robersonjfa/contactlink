class Contact {
  int? id;
  String name;
  String phone;
  String? photo;

  Contact({this.id, required this.name, required this.phone, this.photo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'photo': photo,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      photo: map['photo'],
    );
  }
}

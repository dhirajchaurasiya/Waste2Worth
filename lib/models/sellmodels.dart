class sellmodel {
  String? name;
  String? email;
  String? id;
  double? lat;
  double? long;
  String? weight;
  String? phonenumber;

  sellmodel(
      {this.id,
      this.weight,
      this.phonenumber,
      this.lat,
      this.long,
      this.name,
      this.email});

  sellmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    lat = json['lat'];
    long = json['long'];
    // address = json['address'];
    name = json['name'];
    email = json['email'];
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() => {
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        // ['weight'] = weight;
        // ['address'] = address;
        // ['phonenumber'] = phonenumber;
        // return data;

        'id': id,
        'weight': weight,
        'lat': lat,
        'long': long,
        // 'address': address,
        'name': name,
        'email': email,
        'phonenumber': phonenumber
      };
}

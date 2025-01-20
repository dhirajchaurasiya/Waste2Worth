class sellmodel {
  String? id;
  String? weight;
  String? address;
  String? phonenumber;

  sellmodel({this.id, this.weight, this.address, this.phonenumber});

  sellmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    address = json['address'];
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() => {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    // ['weight'] = weight;
    // ['address'] = address;
    // ['phonenumber'] = phonenumber;
    // return data;

    'id': id,
    'weight':weight,
    'address':address,
    'phonenumber':phonenumber
  };
}

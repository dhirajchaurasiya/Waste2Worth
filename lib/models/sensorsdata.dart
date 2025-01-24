class sensorsdata{
  String? id;
  String? temperature;
  String? humidity;
  // String? phonenumber;

  sensorsdata({this.id, this.temperature, this.humidity});

  sensorsdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    // phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() => {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    // ['weight'] = weight;
    // ['address'] = address;
    // ['phonenumber'] = phonenumber;
    // return data;

    'id': id,
    'temperature':temperature,
    'humidity':humidity
    // 'phonenumber':phonenumber
  };
}

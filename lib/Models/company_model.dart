class CompanyModel {
  int? id;
  String? typeCompany;
  String? nameCompany;
  String? email;
  String? pass;
  String? location;
  String? section;
  String? desc;
  String? special;
  String? img;
  String? phone;
  String? phone2;
  int? countryId;

  CompanyModel({
    this.id,
    this.typeCompany,
    this.nameCompany,
    this.email,
    this.pass,
    this.location,
    this.section,
    this.desc,
    this.special,
    this.img,
    this.phone,
    this.phone2,
    this.countryId = 1,
  });

  CompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeCompany = json['type_Company'];
    nameCompany = json['name_Company'];
    email = json['email'];
    pass = json['pass'];
    location = json['location'];
    section = json['section'];
    desc = json['desc'];
    special = json['special'];
    img = json['img'];
    phone = json['phone'];
    phone2 = json['phone2'];
    countryId = json['countryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_Company'] = typeCompany;
    data['name_Company'] = nameCompany;
    data['email'] = email;
    data['pass'] = pass;
    data['location'] = location;
    data['section'] = section;
    data['desc'] = desc;
    data['special'] = special;
    data['img'] = img;
    data['phone'] = phone;
    data['phone2'] = phone2;
    data['countryId'] = countryId;
    return data;
  }
}

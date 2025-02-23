class ExperienceModel {
  int? id;
  String? nameComp;
  String? typeExper;
  String? startDate;
  String? endDate;
  String? nameExper;
  String? state;
  int? salry;

  ExperienceModel(
      {this.id,
      this.nameComp,
      this.typeExper,
      this.startDate,
      this.endDate,
      this.nameExper,
      this.state,
      this.salry});

  ExperienceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameComp = json['name_comp'];
    typeExper = json['type_Exper'];
    startDate = json['start_Date'];
    endDate = json['end_Date'];
    nameExper = json['name_Exper'];
    state = json['state'];
    salry = json['salry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_comp'] = nameComp;
    data['type_Exper'] = typeExper;
    data['start_Date'] = startDate;
    data['end_Date'] = endDate;
    data['name_Exper'] = nameExper;
    data['state'] = state;
    data['salry'] = salry;
    return data;
  }
}

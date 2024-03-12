class CategoriesModel {
  String? Name;
  String? intro;

  CategoriesModel({this.Name, this.intro});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    Name = json['Name'];
    intro = json['intro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = Name;
    data['intro'] = intro;
    return data;
  }
}

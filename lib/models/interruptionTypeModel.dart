class InterruptionType {
  int id;
  String name;
  String description;
  String imageurl;
  int status;
  String createdAt;
  String updatedAt;

  InterruptionType(
      {this.id,
      this.name,
      this.description,
      this.imageurl,
      this.status,
      this.createdAt,
      this.updatedAt});

  InterruptionType.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageurl = json['imageurl'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageurl'] = this.imageurl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
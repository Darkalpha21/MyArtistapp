class Attachments {
  int? id;
  String? mimetype;
  String? name;
  String? type;
  String? resName;
  String? localUrl;
  String? resModel;
  int? resId;
  String? filepath;
  String? datas;
  String? url;

  Attachments(
      {this.id,
      this.mimetype,
      this.name,
      this.type,
      this.resName,
      this.localUrl,
      this.resModel,
      this.resId,
      this.filepath,
      this.datas,
      this.url});

  static var fields = [ "name",
    "type",
    "local_url",
    "mimetype",
    "res_id",
    "res_name",
    "res_model"];

  factory Attachments.fromJson(Map i, String serverUrl, String session) {
    String imageUrl = "";
    String localUrl = i["local_url"] is! bool ? i["local_url"] : "";
    if(localUrl != "")
      {
        imageUrl = serverUrl +localUrl;
      }
    return Attachments(
      id: i["id"],
      mimetype: i["mimetype"] is! bool ? i["mimetype"] : "",
      name: i["name"] is! bool ? i["name"] : "",
      type: i["type"] is! bool ? i["type"] : "",
      resName: i["res_name"] is! bool ? i["res_name"] : "",
      localUrl: localUrl,
      url: imageUrl,
      resModel: i["res_model"] is! bool ? i["res_model"] : "",
      resId: i["res_id"] is! bool ? i["res_id"] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mimetype': mimetype,
      'name': name,
      'type': type,
      'res_name': resName,
      'url': url,
      'local_url': localUrl,
      'res_model': resModel,
      'res_id': resId,
      'datas': datas
    };
  }

  @override
  String toString() {
    return 'Attachments{name: $name, filepath: $filepath}';
  }
}

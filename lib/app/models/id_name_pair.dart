class IdNamePair {
  int id;
  String name;

  IdNamePair({
    required this.id,
    required this.name,
  });

  factory IdNamePair.fromJson(dynamic json) {
    if (json is List<dynamic> && json.length == 2) {
      return IdNamePair(
        id: json[0] is! bool ? json[0] as int? ?? 0 : 0,
        name: json[1] is! bool ? json[1] as String? ?? '' : "",
      );
    }
    return IdNamePair(id: 0, name: '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return 'IdNamePair{id: $id, name: $name}';
  }
}






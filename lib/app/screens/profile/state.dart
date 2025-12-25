class StateSelection {
  int? id;
  String? name;
  String? code;

  StateSelection({
    this.id,
    this.name,
    this.code
  });

  static var fields = [
    "name","code"
  ];

  factory StateSelection.fromJson(Map i) {
    return StateSelection(
      id: i["id"],
      name: i["name"] is! bool ? i["name"] : "",
      code: i["code"] is! bool ? i["code"] : "",
    );
  }
}

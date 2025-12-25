class CountrySelection {
  int? id;
  String? name;

  CountrySelection({
    this.id,
    this.name,
  });

  static var fields = [
    "name"
  ];

  factory CountrySelection.fromJson(Map i) {
    return CountrySelection(
      id: i["id"],
      name: i["name"] is! bool ? i["name"] : "",
    );
  }
}

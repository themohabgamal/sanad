class Surah {
  String name;
  String arabicName;
  int versesCount;
  int id;
  String revelationPlace;
  int revelationOrder;

  Surah({
    required this.name,
    required this.arabicName,
    required this.versesCount,
    required this.id,
    required this.revelationPlace,
    required this.revelationOrder,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      name: json['name_simple'],
      arabicName: json['name_arabic'],
      versesCount: json['verses_count'],
      id: json['id'],
      revelationPlace: json['revelation_place'],
      revelationOrder: json['revelation_order'],
    );
  }
}

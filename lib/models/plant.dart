import 'package:hive/hive.dart';

part 'plant.g.dart';

@HiveType(typeId: 1)
class Plant extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String scientificName;

  @HiveField(2)
  String commonName;

  @HiveField(3)
  String? imageUrl;

  @HiveField(4)
  String? distribution;

  @HiveField(5)
  String? growth; // bisa string ringkasan seperti bloom_months dan growth_habit

  @HiveField(6)
  String? conservationStatus;

  @HiveField(7)
  String? bibliography;

  Plant({
    required this.id,
    required this.scientificName,
    required this.commonName,
    this.imageUrl,
    this.distribution,
    this.growth,
    this.conservationStatus,
    this.bibliography,
  });
}

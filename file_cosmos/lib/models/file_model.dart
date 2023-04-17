class MyFile {
  String id;
  String name;
  String location;
  String coordinates;

  MyFile({
    required this.id,
    required this.name,
    required this.location,
    required this.coordinates,
  });

  factory MyFile.fromJson(Map<String, dynamic> json) {
    return MyFile(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'coordinates': coordinates,
    };
  }

  @override
  String toString() {
    return 'MyFile{id: $id, name: $name, location: $location, coordinates: $coordinates}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          location == other.location &&
          coordinates == other.coordinates;
  
  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ location.hashCode ^ coordinates.hashCode;


}

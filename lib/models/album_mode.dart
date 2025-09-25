class AlbumMode {
  final String name;
  final int maxPeople;

  const AlbumMode({required this.name, required this.maxPeople});

  static const single = AlbumMode(name: "single", maxPeople: 1);
  static const couple = AlbumMode(name: "couple", maxPeople: 2);
  static const friends = AlbumMode(name: "friends", maxPeople: 5);
  static const friendsPlus = AlbumMode(name: "friends+", maxPeople: 10);

  static List<AlbumMode> values = [single, couple, friends, friendsPlus];

  static AlbumMode fromName(String? name) {
    return values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => single,
    );
  }
}
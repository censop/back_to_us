class AlbumMode {
  final String name;
  final int maxPeople;

  const AlbumMode({required this.name, required this.maxPeople});

  static const single = AlbumMode(name: "Single", maxPeople: 1);
  static const couple = AlbumMode(name: "Couple", maxPeople: 2);
  static const friends = AlbumMode(name: "Friends", maxPeople: 5);
  static const friendsPlus = AlbumMode(name: "Friends+", maxPeople: 10);

  static List<AlbumMode> values = [single, couple, friends, friendsPlus];

  static AlbumMode fromName(String? name) {
    return values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => single,
    );
  }
}
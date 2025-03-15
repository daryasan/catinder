class Cat {
  final String breed;
  final String description;
  final String image;

  const Cat({
    required this.breed,
    required this.description,
    required this.image
  });

  @override
  String toString() {
    return "$breed \n$description";
  }
}
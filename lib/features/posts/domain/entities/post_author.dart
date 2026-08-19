class PostAuthor {
  const PostAuthor({
    required this.id,
    required this.firstName,
    required this.lastName,
  });
  final int id;
  final String firstName;
  final String lastName;
  String get displayName => '$firstName $lastName'.trim();
  String get initials =>
      '${firstName.isEmpty ? '' : firstName[0]}${lastName.isEmpty ? '' : lastName[0]}'
          .toUpperCase();
}
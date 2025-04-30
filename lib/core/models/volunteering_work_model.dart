class VolunteeringWorkModel {
  final String institutionName;
  final String role;
  final DateTime dateStarted;
  final DateTime? dateEnded; // null if ongoing
  final String description;

  VolunteeringWorkModel({
    required this.institutionName,
    required this.role,
    required this.dateStarted,
    this.dateEnded,
    required this.description,
  });
}

class Experience {
  String title;
  String company;
  List<String> responsibilities;
  String period;
  List<String>? extra;

  Experience(
      {required this.title,
      required this.company,
      required this.responsibilities,
      required this.period,
      this.extra});
}

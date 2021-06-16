class Plan {
  final String title;
  bool isChecked;
  String timestamp;
  int index;

  Plan({
    required this.title,
    this.isChecked = false,
    required this.timestamp,
    required this.index,
  });

  void toggleCheckBox() {
    isChecked = !isChecked;
  }

  int compareTo(Plan b) {
    return index.compareTo(b.index);
  }
}

class MultiSelectItem<SlotsGen> {
  final SlotsGen value;
  final String label;
  MultiSelectItem(this.value, this.label);
}

class SlotsGen {
  String day;
  int startTime;
  int endTime;
  String status;

  SlotsGen({this.day, this.startTime, this.endTime, this.status});
}

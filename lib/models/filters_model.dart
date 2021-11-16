class FiltersModel {
  bool showPast = true;
  String? channelName;
  DateTime? dateFrom;
  DateTime? dateTo;

  FiltersModel();

  void reset() {
    channelName = null;
    showPast = true;
    dateFrom = null;
    dateTo = null;
  }
}

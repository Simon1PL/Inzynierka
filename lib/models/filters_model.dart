class FiltersModel {
  bool showPast = false;
  String? channelName;
  DateTime? dateFrom;
  DateTime? dateTo;

  FiltersModel();

  void reset() {
    channelName = null;
    showPast = false;
    dateFrom = null;
    dateTo = null;
  }
}

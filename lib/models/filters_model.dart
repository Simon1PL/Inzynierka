class FiltersModel {
  bool showPast = true;
  String? channelName;
  String? genre;
  DateTime? dateFrom;
  DateTime? dateTo;

  FiltersModel();

  void reset() {
    channelName = null;
    channelName = null;
    showPast = true;
    dateFrom = null;
    dateTo = null;
  }
}

class FiltersModel {
  bool showPast = true;
  String? channelName;
  String? genre;
  DateTime? dateFrom;
  DateTime? dateTo;

  FiltersModel();

  void reset() {
    channelName = null;
    genre = null;
    showPast = true;
    dateFrom = null;
    dateTo = null;
  }
}

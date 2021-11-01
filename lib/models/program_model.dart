class ProgramModel {
  int? orderId;
  String? channelName;
  String? channelId;
  DateTime? start;
  DateTime? stop;
  String? title;
  String? subtitle;
  String? summary;
  String? description;
  int? recordSize;
  String? fileName;
  bool favorite;
  bool alreadyScheduled;

  ProgramModel(
      this.channelName,
      this.channelId,
      int? start,
      int? stop,
      this.title,
      this.subtitle,
      this.summary,
      this.description,
      String? recordSize,
      this.fileName,
      bool? favorite,
      bool? alreadyScheduled,
      [this.orderId])
      : this.start = start != null
            ? new DateTime.fromMillisecondsSinceEpoch(start * 1000)
            : null,
        this.stop = stop != null
            ? new DateTime.fromMillisecondsSinceEpoch(stop * 1000)
            : null,
        this.recordSize = recordSize != null ? int.parse(recordSize) : null,
        this.favorite = favorite != null ? favorite : false,
        this.alreadyScheduled =
            alreadyScheduled != null ? alreadyScheduled : false;
}

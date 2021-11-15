class ProgramModel {
  int? orderId;
  String? channelName;
  String? channelId;
  DateTime? start;
  DateTime? stop;
  String? title;
  String? subtitle;
  String? description;
  int? recordSize;
  String? fileName;
  bool favorite;
  bool favorite2;
  bool alreadyScheduled;
  List<String> genre;
  String? summary;
  String? channelNumber;

  ProgramModel(
      {this.channelName,
      this.channelId,
      int? start,
      int? stop,
      this.title,
      this.subtitle,
      this.summary,
      this.description,
      this.recordSize,
      this.fileName,
      bool? favorite,
      bool? favorite2,
      bool? alreadyScheduled,
      this.orderId,
      this.channelNumber,
        List<String>? genreString,
      List<int> genreInt = const []})
      : this.start = start != null
            ? new DateTime.fromMillisecondsSinceEpoch(start * 1000)
            : null,
        this.stop = stop != null
            ? new DateTime.fromMillisecondsSinceEpoch(stop * 1000)
            : null,
        this.favorite = favorite != null ? favorite : false,
        this.favorite2 = favorite2 != null ? favorite2 : false,
        this.alreadyScheduled =
            alreadyScheduled != null ? alreadyScheduled : false,
        this.genre = genreString != null ? genreString :
            List.from(genreInt.map((e) => ProgramModel.getGenreFromInt(e)));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = orderId.toString();
    data['channelName'] = channelName;
    data['channelId'] = channelId;
    data['start'] = start == null ? 0 : start!.millisecondsSinceEpoch.toString();
    data['stop'] = stop == null ? 0 : stop!.millisecondsSinceEpoch.toString();
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['description'] = description;
    data['recordSize'] = recordSize.toString();
    data['fileName'] = fileName;
    data['favorite'] = favorite.toString();
    data['favorite2'] = favorite2.toString();
    data['alreadyScheduled'] = alreadyScheduled.toString();
    data['genre'] = genre.length > 0 ? genre.first : -1;
    data['summary'] = summary;
    data['channelNumber'] = channelNumber;
    return data;
  }

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(orderId: json["orderId"] == "null" ? null : int.parse(json["orderId"]), channelName: json["channelName"], channelId: json["channelId"], start: int.parse(json["start"]), stop: int.parse(json["stop"]), title: json["title"],subtitle: json["subtitle"], description: json["description"], recordSize: json["recordSize"] == "null" ? null : int.parse(json["recordSize"]),fileName: json["fileName"], favorite: json["favorite"].toLowerCase() == "true", favorite2: json["favorite2"].toLowerCase() == "true",alreadyScheduled: json["alreadyScheduled"].toLowerCase() == "true", genreString: [json["genre"]],summary: json["summary"], channelNumber: json["channelNumber"],);
  }

  static String getGenreFromInt(int genre) {
    switch (genre) {
      // Movie/Drama:
      case 16:
        return "movie/drama";
      case 17:
        return "detective/thriller";
      case 18:
        return "adventure/western/war";
      case 19:
        return "science fiction/fantasy/horror";
      case 20:
        return "comedy";
      case 21:
        return "soap/melodram/folkloric";
      case 22:
        return "romance";
      case 23:
        return "serious/classical/religious/historical movie/drama";
      case 24:
        return "adult movie/drama";
      case 25:
        return "to 0xE reserved for future use";
      case 31:
        return "user defined";
      // News/Current affairs:
      case 32:
        return "news/current affairs";
      case 33:
        return "news/weather report";
      case 34:
        return "news magazine";
      case 35:
        return "documentary";
      case 36:
        return "discussion/interview/debate";
      case 37:
        return "to 0xE reserved for future use";
      case 47:
        return "user defined";
      // Show/Gameshow:
      case 48:
        return "show/game show";
      case 49:
        return "game show/quiz/contest";
      case 50:
        return "variety show";
      case 51:
        return "talk show";
      case 52:
        return "to 0xE reserved for future use";
      case 63:
        return "user defined";
      // Sports:
      case 64:
        return "sports";
      case 65:
        return "special events (Olympic Games, World Cup, etc.)";
      case 66:
        return "sports magazines";
      case 67:
        return "football/soccer";
      case 68:
        return "tennis/squash";
      case 69:
        return "team sports (excluding football)";
      case 70:
        return "athletics";
      case 71:
        return "motor sport";
      case 72:
        return "water sport";
      case 73:
        return "winter sports";
      case 74:
        return "equestrian";
      case 75:
        return "martial sports";
      case 76:
        return "to 0xE reserved for future use";
      case 79:
        return "user defined";
      // Children's/Youth programmes:
      case 80:
        return "children's/youth programmes";
      case 81:
        return "pre-school children's programmes";
      case 82:
        return "entertainment programmes for 6 to14";
      case 83:
        return "entertainment programmes for 10 to 16";
      case 84:
        return "informational/educational/school programmes";
      case 85:
        return "cartoons/puppets";
      case 86:
        return "to 0xE reserved for future use";
      case 95:
        return "user defined";
      // Music/Ballet/Dance:
      case 96:
        return "music/ballet/dance";
      case 97:
        return "rock/pop";
      case 98:
        return "serious music/classical music";
      case 99:
        return "folk/traditional music";
      case 100:
        return "jazz";
      case 101:
        return "musical/opera";
      case 102:
        return "ballet";
      case 103:
        return "to 0xE reserved for future use";
      case 111:
        return "user defined";
      // Arts/Culture (without music):
      case 112:
        return "arts/culture (without music)";
      case 113:
        return "performing arts";
      case 114:
        return "fine arts";
      case 115:
        return "religion";
      case 116:
        return "popular culture/traditional arts";
      case 117:
        return "literature";
      case 118:
        return "film/cinema";
      case 119:
        return "experimental film/video";
      case 120:
        return "broadcasting/press";
      case 121:
        return "new media";
      case 122:
        return "arts/culture magazines";
      case 123:
        return "fashion";
      case 124:
        return "to 0xE reserved for future use";
      case 127:
        return "user defined";
      // Social/Political issues/Economics:
      case 128:
        return "social/political issues/economics";
      case 129:
        return "magazines/reports/documentary";
      case 130:
        return "economics/social advisory";
      case 131:
        return "remarkable people";
      case 132:
        return "to 0xE reserved for future use";
      case 143:
        return "user defined";
      // Education/Science/Factual topics:
      case 144:
        return "education/science/factual topics";
      case 145:
        return "nature/animals/environment";
      case 146:
        return "technology/natural sciences";
      case 147:
        return "medicine/physiology/psychology";
      case 148:
        return "foreign countries/expeditions";
      case 149:
        return "social/spiritual sciences";
      case 150:
        return "further education";
      case 151:
        return "languages";
      case 152:
        return "to 0xE reserved for future use";
      case 159:
        return "user defined";
      // Leisure hobbies:
      case 160:
        return "leisure hobbies";
      case 161:
        return "tourism/travel";
      case 162:
        return "handicraft";
      case 163:
        return "motoring";
      case 164:
        return "fitness and health";
      case 165:
        return "cooking";
      case 166:
        return "advertisement/shopping";
      case 167:
        return "gardening";
      case 168:
        return "to 0xE reserved for future use";
      case 175:
        return "user defined";
      default:
        return genre.toString();
    }
  }
}

import 'package:projekt/enums/user_role_for_tuner.dart';

class TunerModel {
  int tunerId;
  String name;
  late UserRoleForTuner currentUserRole;

  TunerModel(this.tunerId, this.name, String currentUserRole) {
    this.currentUserRole = getUserRoleFromString(currentUserRole);
  }

  static UserRoleForTuner getUserRoleFromString(String currentUserRole) {
    switch (currentUserRole) {
      case "owner":
      case "Owner":
        return UserRoleForTuner.OWNER;
      case "user":
      case "User":
        return UserRoleForTuner.USER;
      case "invited":
      case "Invited":
        return UserRoleForTuner.INVITED;
      case "declined":
      case "Declined":
        return UserRoleForTuner.DECLINED;
      default:
        return UserRoleForTuner.UNKNOWN;
    }
  }

  static String getUserRoleAsString(UserRoleForTuner currentUserRole) {
    switch (currentUserRole) {
      case UserRoleForTuner.OWNER:
        return "Owner";
      case UserRoleForTuner.USER:
        return "User";
      case UserRoleForTuner.INVITED:
        return "Invited";
      case UserRoleForTuner.DECLINED:
        return "Declined";
      default:
        return "Unknown";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    var role = getUserRoleAsString(currentUserRole);
    data['tunerId'] = this.tunerId;
    data['name'] = this.name;
    data['currentUserRole'] = role;
    return data;
  }

  factory TunerModel.fromJson(Map<String, dynamic> json) {
    return TunerModel(json["tunerId"], json["name"], json["currentUserRole"]);
  }
}

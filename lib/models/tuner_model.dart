import 'package:projekt/enums/user_role_for_tuner.dart';

class TunerModel {
  int tunerId;
  String? name;
  UserRoleForTuner? currentUserRole;

  TunerModel(this.tunerId, this.name, [String? currentUserRole]) {
    this.currentUserRole = getUserRoleFromString(currentUserRole);
  }

  static UserRoleForTuner? getUserRoleFromString(String? currentUserRole) {
    switch (currentUserRole) {
      case "owner":
        return UserRoleForTuner.OWNER;
      case "user":
        return UserRoleForTuner.USER;
    }
  }

  static String getUserRoleAsString(UserRoleForTuner? currentUserRole) {
    switch (currentUserRole) {
      case UserRoleForTuner.OWNER:
        return "Owner";
      case UserRoleForTuner.USER:
        return "User";
    }
    return "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    var role = currentUserRole == UserRoleForTuner.OWNER ? "owner" : "user";
    data['tunerId'] = this.tunerId;
    data['name'] = this.name;
    data['currentUserRole'] = role;
    return data;
  }

  factory TunerModel.fromJson(Map<String, dynamic> json) {
    var tuner = TunerModel(-1, "");
    tuner.tunerId = json["tunerId"];
    tuner.name = json["name"];
    tuner.currentUserRole = getUserRoleFromString(json["currentUserRole"]);
    return tuner;
  }
}

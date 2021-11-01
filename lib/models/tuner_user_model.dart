import 'package:projekt/enums/user_role_for_tuner.dart';

class TunerUserModel {
  int userId;
  String? username;
  UserRoleForTuner? userRole;

  TunerUserModel(this.userId, this.username, String userRole) {
    switch (userRole) {
      case "owner":
        this.userRole = UserRoleForTuner.OWNER;
        break;
      case "user":
        this.userRole = UserRoleForTuner.USER;
        break;
    }
  }
}

import 'package:projekt/enums/user_role_for_tuner.dart';
import 'package:projekt/models/tuner_model.dart';

class TunerUserModel {
  int userId;
  String username;
  late UserRoleForTuner userRole;

  TunerUserModel(this.userId, this.username, String userRole) {
      this.userRole = TunerModel.getUserRoleFromString(userRole);
  }
}

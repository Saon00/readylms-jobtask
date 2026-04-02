import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readylms_jobtask/core/values/app_icons.dart';
import '../model/role_model.dart';

final roleProvider = NotifierProvider<RoleController, String?>(
  RoleController.new,
);

class RoleController extends Notifier<String?> {
  @override
  String? build() {
    return null; // Initially no role selected
  }

  final List<RoleModel> roles = [
    RoleModel(
      id: 'student',
      name: 'Student',
      description: 'Browse courses, learn new skills',
      iconCodePoint: AppIcons.bookLogo, 
    ),
    RoleModel(
      id: 'instructor',
      name: 'Instructor',
      description: 'Create courses, teach students, and earn',
      iconCodePoint: AppIcons.mentorLogo, 
    ),
  ];

  void selectRole(String roleId) {
    state = roleId;
  }

  void clearRole() {
    state = null;
  }

  bool get isRoleSelected => state != null;

  RoleModel? getSelectedRole() {
    if (state == null) return null;
    return roles.firstWhere((role) => role.id == state);
  }
}

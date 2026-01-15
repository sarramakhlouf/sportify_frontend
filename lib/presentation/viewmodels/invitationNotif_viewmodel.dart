import 'package:flutter/material.dart';
import 'package:sportify_frontend/domain/entities/invitationNotif.dart';
import 'package:sportify_frontend/domain/usecases/get_invitation_notifications_usecase.dart';

class InvitationNotificationViewModel extends ChangeNotifier {
  final GetInvitationNotificationsUseCase getInvitations;

  InvitationNotificationViewModel(this.getInvitations);

  bool isLoading = false;
  String? error;
  List<InvitationNotif> invitations = [];

  Future<void> loadInvitations() async {
    try {
      isLoading = true;
      notifyListeners();

      invitations = await getInvitations();
    } catch (e) {
      error = 'Erreur lors du chargement des invitations';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

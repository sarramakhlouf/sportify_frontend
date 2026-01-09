import 'package:flutter/material.dart';
import 'package:sportify_frontend/domain/entities/Invitation.dart';
import 'package:sportify_frontend/domain/usecases/get_pending_invitations.dart';
import 'package:sportify_frontend/domain/usecases/invite_player_usecase.dart';

class InvitationViewModel extends ChangeNotifier {
  final InvitePlayerUsecase invitePlayerUseCase;
  final GetPendingInvitationsUseCase getPendingInvitationsUseCase;

  InvitationViewModel(
    this.invitePlayerUseCase,
    this.getPendingInvitationsUseCase
  );

  bool isLoading = false;
  String? error;
  int pendingCount = 0; 
  List<Invitation> pendingInvitations = [];

  Future<bool> invite({
    required String teamId,
    required String senderId,
    required String playerCode,
  }) async {
    if (playerCode.length != 8) {
      error = 'Le code doit contenir 8 caractères';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await invitePlayerUseCase(
        teamId: teamId,
        senderId: senderId,
        playerCode: playerCode,
      );

      return true;
    } catch (e) {
      final msg = e.toString();

      if (msg.contains('PLAYER_NOT_FOUND')) {
        error = 'Joueur introuvable';
      } else if (msg.contains('ALREADY_MEMBER')) {
        error = 'Ce joueur est déjà dans l’équipe';
      } else {
        error = 'Erreur lors de l’invitation';
      }

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

 Future<void> loadPendingInvitations(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      pendingInvitations =
          await getPendingInvitationsUseCase(userId);

      pendingCount = pendingInvitations.length;
    } catch (e) {
      error = 'Erreur lors du chargement des invitations';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

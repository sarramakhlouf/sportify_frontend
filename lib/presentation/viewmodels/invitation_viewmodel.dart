import 'package:flutter/material.dart';
import 'package:sportify_frontend/domain/usecases/invite_player_usecase.dart';

class InvitationViewModel extends ChangeNotifier {
  final InvitePlayerUseCase invitePlayerUseCase;

  InvitationViewModel(this.invitePlayerUseCase);

  bool isLoading = false;
  String? error;

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

      await invitePlayerUseCase.execute(
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
}


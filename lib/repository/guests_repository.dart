
import 'package:wedding_guest/model/guest.dart';

abstract class GuestsRepository {
  Future<void> createGuest(Guest guest, String weddingId);
  Future<void> updateGuest(Guest guest, String weddingId);
  Stream<List<Guest>> readGuest(String weddingId);
  Future<Guest> readGuestByID(String weddingId,String guestID);
  Future<void> deleteGuest(Guest guest, String weddingId);
}
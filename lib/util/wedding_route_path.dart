class WeddingGuestRoutePath {
  final String weddingID;
  final String guestID;
  final bool isUnknown;
  final bool isDone;

  WeddingGuestRoutePath.register(this.weddingID)
      : guestID = null,
        isUnknown = false,
        isDone = false;

  WeddingGuestRoutePath.inputDetails(this.weddingID, this.guestID) : isUnknown = false, isDone = false;

  WeddingGuestRoutePath.unknown()
      : weddingID = null,
        guestID = null,
        isUnknown = true,
        isDone= false;

  WeddingGuestRoutePath.Done()
      : weddingID = null,
        guestID = null,
        isUnknown = false,
        isDone= true;

  bool get isRegisterPage => weddingID != null && guestID == null;

  bool get isInputDetailsPage => weddingID != null && guestID != null;
}
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_guest/model/guest.dart';
import 'package:wedding_guest/model/notification.dart';
import 'package:wedding_guest/repository/guests_repository.dart';
import 'package:wedding_guest/repository/notification_repository.dart';
import 'bloc.dart';


class GuestsBloc extends Bloc<GuestsEvent, GuestsState> {
  final GuestsRepository _guestsRepository;
  final NotificationRepository _notiRepository;
  StreamSubscription _guestsSubscription;
  StreamSubscription _notiSubscription;

  GuestsBloc({@required GuestsRepository guestsRepository, @required NotificationRepository notificationRepository})
      : assert(guestsRepository != null && notificationRepository != null),
        _guestsRepository = guestsRepository,
        _notiRepository = notificationRepository,
        super(GuestsLoading());

  NotificationModel fromGuest(Guest guest,String weddingID, List<NotificationModel> notifications){
    int number =1;
    bool isUpdating = false;
    for(int i=0; i<notifications.length; i++){
      if(guest.id == notifications[i].detailsID){
        number = notifications[i].number;
        isUpdating =true;
        break;
      }
      if(notifications[i].number >= number)
        number = notifications[i].number;
    }
    NotificationModel notificationModel = new NotificationModel(
        content: "${guest.name} đã phản hồi lời mời",
        read: true,
        type: 2,
        date: DateTime.now().add(Duration(minutes: 2)),
        detailsID: guest.id,
        isNew: true,
        number: isUpdating ? number : (number +1));

    return notificationModel;
  }

  @override
  Stream<GuestsState> mapEventToState(GuestsEvent event) async* {
    if(event is LoadGuests){
      yield* _mapLoadGuestsToState(event);
    }else if(event is UpdateGuest){
      yield* _mapUpdateGuestToState(event);
    }else if(event is DeleteGuest){
      yield* _mapDeleteGuestToState(event);
    }else if(event is ToggleAll){
      yield* _mapToggleAllToState(event);
    }else if(event is ClearCompleted){
      yield* _mapClearCompletedToState();
    }else if (event is SearchGuests) {
      yield* _mapSearchingToState();
    }else if (event is LoadGuestByID) {
      yield* _mapLoadByIDToState(event);
    }else if (event is ChooseCompanion) {
      yield* _mapChooseCompanionToState();
    }
  }

  Stream<GuestsState> _mapLoadGuestsToState(LoadGuests event) async*{
    _guestsSubscription?.cancel();
    _notiSubscription?.cancel();
    _guestsSubscription = _guestsRepository.readGuest(event.weddingId).listen(
            (guests) => add(ToggleAll(guests)),
    );
  }

  bool isUpdate = false;
  Stream<GuestsState> _mapUpdateGuestToState(UpdateGuest event) async*{
    _guestsRepository.updateGuest(event.guest, event.weddingId);
    _notiSubscription?.cancel();
    isUpdate = true;
    _notiSubscription = _notiRepository.getNotifications(event.weddingId).listen(
          (notis) {
            NotificationModel noti = fromGuest(event.guest, event.weddingId, notis);
            print("NOTI "+noti.toString());
            _notiRepository.updateNotificationByTaskID(noti, event.weddingId);
            _notiSubscription?.cancel();
          }
    );
    yield GuestUpdated();
  }

  Stream<GuestsState> _mapDeleteGuestToState(DeleteGuest event) async*{
    _guestsRepository.deleteGuest(event.guest, event.weddingId);
    yield GuestDeleted();
  }

  Stream<GuestsState> _mapToggleAllToState(ToggleAll event) async*{
    yield GuestsLoaded(event.guests);
  }

  Stream<GuestsState> _mapClearCompletedToState() async*{}

  Stream<GuestsState> _mapSearchingToState() async* {
    yield GuestsSearching();
  }

  Stream<GuestsState> _mapChooseCompanionToState() async* {
    yield CompanionChose();
  }

  Stream<GuestsState> _mapLoadByIDToState(LoadGuestByID event) async* {
    Guest guest = await _guestsRepository.readGuestByID(event.weddingId, event.guestID);
    yield GuestsLoadedByID(guest);
  }

  @override
  Future<void> close() {
    _guestsSubscription?.cancel();
    return super.close();
  }
}
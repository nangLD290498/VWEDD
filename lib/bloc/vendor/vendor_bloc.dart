import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_guest/bloc/vendor/vendor_bloc_event.dart';
import 'package:wedding_guest/bloc/vendor/vendor_bloc_state.dart';
import 'package:wedding_guest/repository/vendor_repository.dart';
import 'bloc.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final VendorRepository _vendorRepository;
  StreamSubscription _vendorSubscription;

  VendorBloc({@required VendorRepository todosRepository})
      : assert(todosRepository != null),
        _vendorRepository = todosRepository,
        super(VendorLoading());

  @override
  Stream<VendorState> mapEventToState(VendorEvent event) async* {
    if (event is LoadVendor) {
      yield* _mapLoadVendorToState();
    } else if (event is VendorUpdated) {
      yield* _mapVendorUpdateToState(event);
    } else if (event is AddVendor) {
      yield* _mapAddVendorToState(event);
    } else if( event is UpdateVendor){
      yield* _mapUpdateVendorToState(event);
    }else if (event is DeleteVendor) {
      yield* _mapDeleteVendorToState(event);
    }else if (event is GetAllVendor) {
      yield* _mapGetAllVendorToState(event);
    }
  }

  Stream<VendorState> _mapLoadVendorToState() async* {
    _vendorSubscription?.cancel();
    _vendorSubscription = _vendorRepository.getallVendor().listen(
          (vendors) => add(VendorUpdated(vendors)),
        );
  }

  Stream<VendorState> _mapVendorUpdateToState(VendorUpdated event) async* {
    yield VendorLoaded(event.vendors);
  }

  Stream<VendorState> _mapAddVendorToState(AddVendor event) async* {
    yield Loading("Đang xử lý dữ liệu");
    try {
      await _vendorRepository.createVendor(event.vendor);
      yield Success("Tạo thành công");
    } catch (_) {
      yield Failed("Có lỗi xảy ra");
    }
  }

  Stream<VendorState> _mapUpdateVendorToState(UpdateVendor event) async* {
    _vendorRepository.updateVendor(event.updatedVendor);
    yield VendorUpdate();
  }

  Stream<VendorState> _mapDeleteVendorToState(DeleteVendor event) async* {
    _vendorRepository.deleteVendor(event.vendorId);
  }

  Stream<VendorState> _mapGetAllVendorToState(GetAllVendor event) async* {
    _vendorSubscription =
        _vendorRepository.getallVendor().listen(
              (budgets) => add(VendorUpdated(budgets)),
            );
  }

  @override
  Future<void> close() {
    _vendorSubscription?.cancel();
    return super.close();
  }
}

import 'package:equatable/equatable.dart';
import 'package:wedding_guest/model/vendor.dart';


abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object> get props => [];
}

class LoadVendor extends VendorEvent {}

class GetAllVendor extends VendorEvent {
  const GetAllVendor();
}

class GetVendorById extends VendorEvent {
  final String vendorId;
  
  GetVendorById(this.vendorId);

  List<Object> get props => [vendorId];
}

class AddVendor extends VendorEvent {
  final Vendor vendor;

  const AddVendor(this.vendor);

  @override
  List<Object> get props => [vendor];

  @override
  String toString() {
    return 'AddVendor{vendor: $vendor}';
  }
}

class UpdateVendor extends VendorEvent {
  final Vendor updatedVendor;

  const UpdateVendor(this.updatedVendor);

  @override
  List<Object> get props => [updatedVendor];

  @override
  String toString() {
    return 'UpdateVendor{updatedVendor: $updatedVendor}';
  }
}

class DeleteVendor extends VendorEvent {
  final String vendorId;

  const DeleteVendor(this.vendorId);
}

class ClearCompleted extends VendorEvent {}

class ToggleAll extends VendorEvent {}

class VendorUpdated extends VendorEvent {
  final List<Vendor> vendors;

  const VendorUpdated(this.vendors);

  @override
  List<Object> get props => [vendors];
}
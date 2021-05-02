import 'package:equatable/equatable.dart';

import 'package:wedding_guest/model/vendor.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object> get props => [];
}

class VendorLoading extends VendorState {}

class VendorUpdate extends VendorState {
}
class GetVendor extends VendorState{
  final Vendor vendor;


  const GetVendor(this.vendor);
  @override
  List<Object> get props => [vendor];

}

class VendorLoaded extends VendorState {
  final List<Vendor> vendors;

  const VendorLoaded([this.vendors = const []]);

  @override
  List<Object> get props => [vendors];

  @override
  String toString() {
    return 'VendorLoaded{vendors: $vendors}';
  }
}

class VendorNotLoaded extends VendorState {}

class Success extends VendorState {
  final String message;

  const Success(this.message);

  @override
  List<Object> get props => [message];
}

class Failed extends VendorState {
  final String message;

  const Failed(this.message);

  @override
  List<Object> get props => [message];
}

class Loading extends VendorState {
  final String message;

  const Loading(this.message);

  @override
  List<Object> get props => [message];
}
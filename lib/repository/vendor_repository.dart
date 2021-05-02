
import 'package:wedding_guest/model/vendor.dart';

abstract class VendorRepository {
  Stream<List<Vendor>> getallVendor();
  Future<void> createVendor(Vendor vendor);
  Future<void> updateVendor(Vendor vendor);
  Stream<Vendor> getVendor(String vendorId);
  Future<void> deleteVendor(String vendorId);
  Future<Vendor> getVendorById(String vendorId);
}
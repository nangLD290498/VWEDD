import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_guest/entity/vendor_entity.dart';
import 'package:wedding_guest/model/vendor.dart';
import 'package:wedding_guest/repository/vendor_repository.dart';


class FirebaseVendorRepository implements VendorRepository {
  final vendorCollection = FirebaseFirestore.instance.collection('vendor');


  @override
  Stream<List<Vendor>> getallVendor() {
    return vendorCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Vendor.fromEntity(VendorEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> createVendor(Vendor vendor) async {
    return vendorCollection.add(vendor.toEntity().toDocument());
  }
  @override
  Future<void> updateVendor(Vendor vendor) {
    return vendorCollection
        .doc(vendor.id)
        .update(vendor.toEntity().toDocument());
  }
   @override
  Stream<Vendor> getVendor(String vendorId) {
    return vendorCollection.doc(vendorId).snapshots().map(
        (snapshot) => Vendor.fromEntity(VendorEntity.fromSnapshot(snapshot)));
  }
  @override
  Future<void> deleteVendor(String vendorId) {
    return vendorCollection.doc(vendorId).delete();
  }
  @override
  Future<Vendor> getVendorById(String vendorId) async {
    DocumentSnapshot snapshot = await vendorCollection.doc(vendorId).get();
    return Vendor.fromEntity(VendorEntity.fromSnapshot(snapshot));
  }
}
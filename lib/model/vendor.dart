import 'package:wedding_guest/entity/vendor_entity.dart';

class Vendor {
  String id;
  String label;
  String name;
  String cateID;
  String location;
  String description;
  String frontImage;
  String ownerImage;
  String email;
  String phone;

  Vendor(
    this.label, 
    this.name, 
    this.cateID, 
    this.location,
    this.description, 
    this.frontImage,
    this.ownerImage,
    this.email,
    this.phone,
    {String id})
      : this.id = id;

  Vendor.fromMap(Map<dynamic, dynamic> map)
      : this.id = map['id'],
        this.label = map['budgetName'],
        this.name= map['name'],
        this.cateID = map['cateID'],
        this.location = map['location'],
        this.description = map['description'],
        this.frontImage = map['frontImage'],
        this.ownerImage = map['ownerImage'],
        this.email = map['email'],
        this.phone = map['phone'];

  Map toMap() {
    return {
      'id': this.id,
      'label': this.label,
      'name':this.name,
      'cateID': this.cateID,
      'location': this.location,
      'description': this.description,
      'frontImage': this.frontImage,
      'ownerImage': this.ownerImage,
      'email': this.email,
      'phone': this.phone,
    };
  }

  Vendor copyWith(
      {String id,
        String label,
        String name,
        String cateID,
        String location,
        String description,
        String frontImage,
        String ownerImage,
        String email,
        String phone
      }) {
    return Vendor(
        label ?? this.label,
        name?? this.name,
        cateID ?? this.cateID,
         location?? this.location,
        description ?? this.description,
         frontImage?? this.frontImage,
         ownerImage?? this.ownerImage,
         email?? this.email,
         phone?? this.phone,
         id: id ?? this.id,);
        
  }


  VendorEntity toEntity() {
    return VendorEntity(
        id, label,name, cateID, location, description, frontImage, ownerImage,email,phone);
  }

  bool operator ==(o) =>
      o is Vendor &&
          o.label == label &&
          o.id == id &&
          o.name==name &&
          o.cateID == cateID &&
          o.location == location &&
          o.description == description &&
          o.frontImage == frontImage &&
          o.ownerImage == ownerImage &&
          o.email == email &&
          o.phone == phone;

  static Vendor fromEntity(VendorEntity entity) {
    return Vendor(
        entity.label,
        entity.name,
        entity.cateID,
        entity.location,
        entity.description,
        entity.frontImage,
        entity.ownerImage,
        entity.email,
        entity.phone,
        id: entity.id,
        )
    ;
  }

  @override
  String toString() {
    return 'Vendor{id: $id, label: $label, name: $name, cateID: $cateID, location: $location, description: $description, frontImage: $frontImage, ownerImage: $ownerImage}';
  }
}


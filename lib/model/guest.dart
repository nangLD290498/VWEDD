

import 'package:wedding_guest/entity/guest_entity.dart';

class Guest{
  String id;
  String name;
  String description;
  int status;
  String phone;
  int companion;
  String congrat;
  int money;
  int type;

  Guest(this.name, this.description, this.status, this.phone,
      this.companion,
      this.congrat,
      this.money,
      this.type,
      {this.id});

  Guest copyWith({
    String id,
    String name,
    String description,
    int status,
    String phone,
    int companion,
    String congrat,
    int money,
    int type,
  }){
    return Guest(
      name ?? this.name,
      description ?? this.description,
      status ?? this.status,
      phone ?? this.phone,
      companion ?? this.companion,
      congrat ?? this.congrat,
      money ?? this.money,
      type ?? this.type,
      id: id ?? this.id
    );
  }

  GuestEntity toEntity(){
    return GuestEntity(id, name, description, status, phone,companion,congrat,money,type);
  }

  static Guest fromEntity(GuestEntity entity){
    return Guest(
        entity.name,
        entity.description,
        entity.status,
        entity.phone,
        entity.companion,
        entity.congrat,
        entity.money,
        entity.type,
        id: entity.id,
    );
  }

  @override
  String toString() {
    return name +"|"+ description +"|"+ status.toString() +"|"+ phone +"|"+companion.toString()+"|"
        +congrat+"|"+money.toString()+"|"+type.toString();
  }
}
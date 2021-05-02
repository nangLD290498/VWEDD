class AdminVendorRoutePath {
  final String adminID;
  final String vendorID;
  final bool isUnknown;
  final bool isAdd;
  final bool isHome;
  final String weddingID;
  final String guestID;
  final bool isDone;

  AdminVendorRoutePath.inputDetailsVendor(this.adminID, this.vendorID) : isUnknown = false, isAdd = false, isHome = false, weddingID =null, guestID=null, isDone = false;
  AdminVendorRoutePath.login()
      : adminID = null,
        vendorID = null,
        isUnknown = false,
        isHome = false,
        isAdd= false,
        weddingID=null,
        guestID = null,
        isDone = false
        ;
  AdminVendorRoutePath.allVendor(this.adminID)
      :vendorID = null,
        isUnknown = false,
        isHome = false,
        isAdd= false,
        weddingID=null,
        guestID = null,
        isDone = false
        ;
  AdminVendorRoutePath.unknown()
      : adminID = null,
        vendorID = null,
        isUnknown = true,
        isHome = false,
        isAdd= false,
        weddingID=null,
        guestID = null,
        isDone = false
        ;

  AdminVendorRoutePath.add(this.adminID)
      : vendorID = null,
        isUnknown = false,
        isHome = false,
        isAdd= true,
        weddingID=null,
        guestID = null,
        isDone = false
        ;

  AdminVendorRoutePath.homeVendor(this.adminID)
      :vendorID = null,
        isUnknown = false,
        isHome = true,
        isAdd= false,
        weddingID=null,
        guestID = null,
        isDone = false
        ;
   AdminVendorRoutePath.register(this.weddingID)
      : guestID = null,
        isUnknown = false,
        isDone = false,
        vendorID = null,
        adminID = null,
        isHome = false,
        isAdd= false
        ;

  AdminVendorRoutePath.inputDetails(this.weddingID, this.guestID) 
      : isUnknown = false,
        isDone = false,
        vendorID = null,
        adminID = null,
        isHome = false,
        isAdd= false
        ;

   AdminVendorRoutePath.Done()
      : weddingID = null,
        guestID = null,
        isUnknown = false,
        isDone= true,
        vendorID = null,
        adminID = null,
        isHome = false,
        isAdd= false
        ;

  bool get isAddPage => adminID != null && vendorID == null && isAdd == true && isHome==false && weddingID == null && guestID == null && isUnknown == false && isDone==false;
  bool get isLoginPage => adminID == null && vendorID == null && isUnknown == false && isAdd==false && isHome==false && weddingID == null && guestID == null  && isDone==false;
  bool get isHomeVendorPage => adminID != null && vendorID == null && isAdd == false && isHome == true  && weddingID == null && guestID == null && isUnknown == false && isDone==false;
  bool get isInputDetailsVendorPage => adminID != null && vendorID != null && isAdd == false && isHome == false && weddingID == null && guestID == null && isUnknown == false && isDone==false;
  bool get isAllVendorPage => adminID != null && vendorID == null  && isAdd == false && isHome == false && weddingID == null && guestID == null && isUnknown == false && isDone==false;
  bool get isRegisterPage => weddingID != null && guestID == null && isDone==false && vendorID == null && adminID == null && isHome == false && isAdd == false && isUnknown == false;
  bool get isInputDetailsPage => weddingID != null && guestID != null&& isDone==false && vendorID == null && adminID == null && isHome == false && isAdd == false && isUnknown == false;
}
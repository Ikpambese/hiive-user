class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerAvatarUrl;
  String? sellerEmail;
  String? sellerState;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvatarUrl,
    this.sellerEmail,
    this.sellerState,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json['sellerUID'];
    sellerName = json['sellerName'];
    sellerAvatarUrl = json['sellerAvatarUrl'];
    sellerEmail = json['sellerEmail'];
    sellerState = json['sellerState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sellerUID'] = sellerUID;
    data['sellerName'] = sellerName;
    data['sellerAvatarUrl'] = sellerAvatarUrl;
    data['sellerEmail'] = sellerEmail;
    data['sellerState'] = sellerState;
    return data;
  }
}

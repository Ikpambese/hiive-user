// import 'package:cloud_firestore/cloud_firestore.dart';

// class Items {
//   String? menuID;
//   String? sellerUID;
//   String? itemID;
//   String? title;
//   String? shortInfo;
//   Timestamp? publishedDate;
//   String? thumbnailUrl;
//   String? longDescription;
//   String? status;
//   int? price;

//   Items({
//     this.menuID,
//     this.sellerUID,
//     this.itemID,
//     this.title,
//     this.shortInfo,
//     this.publishedDate,
//     this.thumbnailUrl,
//     this.longDescription,
//     this.status,
//     this.price,
//   });

//   Items.fromJson(Map<String, dynamic> json) {
//     menuID = json['menuID '];
//     sellerUID = json['sellerUID'];
//     itemID = json['itemID'];
//     title = json['title'];
//     shortInfo = json['shortInfo'];
//     publishedDate = json['publishedDate'];
//     thumbnailUrl = json['thumbnailUrl'];
//     longDescription = json['longDescription'];
//     status = json['status'];
//     price = json['price'];
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['menuID'] = menuID;
//     data['sellerUID'] = sellerUID;
//     data['itemID'] = itemID;
//     data['title'] = title;
//     data['shortInfo'] = shortInfo;
//     data['publishedDate'] = publishedDate;
//     data['thumbnailUrl'] = thumbnailUrl;
//     data['longDescription'] = longDescription;
//     data['status'] = status;
//     data['price'] = price;
//     return data;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  Items({
    this.menuID,
    this.sellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.price,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    // Fix: Removed trailing space from 'menuID '
    return Items(
      menuID: json['menuID'] as String?,
      sellerUID: json['sellerUID'] as String?,
      itemID: json['itemID'] as String?,
      title: json['title'] as String?,
      shortInfo: json['shortInfo'] as String?,
      publishedDate: json['publishedDate'] as Timestamp?,
      thumbnailUrl: _validateImageUrl(json['thumbnailUrl'] as String?),
      longDescription: json['longDescription'] as String?,
      status: json['status'] as String?,
      price: json['price'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuID'] = menuID;
    data['sellerUID'] = sellerUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['longDescription'] = longDescription;
    data['status'] = status;
    data['price'] = price;
    return data;
  }

  // Helper method to validate image URLs
  static String? _validateImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return null;
    }

    // Ensure URL has proper scheme
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      // You might want to prepend your default domain here if using relative paths
      // return 'https://yourdomain.com/$url';
      return null;
    }

    return url;
  }

  // Method to get a safe thumbnail URL with fallback
  String get safeThumbnailUrl {
    return thumbnailUrl ?? 'https://via.placeholder.com/150';
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/model/customer.dart';
import 'package:pet_care_customer/model/invoice.dart';
import 'package:pet_care_customer/model/item_warehouse.dart';
import 'package:pet_care_customer/model/order_model.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/model/room.dart';
import 'package:pet_care_customer/model/service.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/model/user_request.dart';
import 'package:pet_care_customer/model/voucher.dart';

import '../model/warehouse.dart';

class FirebaseHelper {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static const Duration timeout = Duration(milliseconds: 1000);

  static Future<QuerySnapshot?> login(UserRequest user) async {
    QuerySnapshot? result = await database
        .collection(Constants.users)
        .where(
          Constants.username,
          isEqualTo: user.name,
        )
        .where(Constants.password, isEqualTo: user.password)
        .where(Constants.typeAccount, isEqualTo: Constants.typeCustomer)
        .get()
        .timeout(timeout);
    return result;
  }

  static Future<DocumentReference> register(UserResponse data) async {
    DocumentReference result =
        await database.collection(Constants.users).add(data.toMap());
    return result;
  }

  static Future<String?> getCustomer(String phone) async {
    String? id;
    await database
        .collection(Constants.customers)
        .where(Constants.phone, isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        id = value.docs[0].id;
      }
    });
    return id;
  }

  static Future<QuerySnapshot?> getAllStaff(String username) async {
    QuerySnapshot? result = await database
        .collection(Constants.users)
        .where(Constants.username, isNotEqualTo: username)
        .get()
        .timeout(timeout);
    return result;
  }

  static Future<QuerySnapshot> getAllManager() async {
    return database.collection(Constants.users)
        .where(Constants.typeAccount, isNotEqualTo: Constants.typeCustomer)
        .get();
  }


  static Future<void> editUser(UserResponse data) async {
    return await database
        .collection(Constants.users)
        .doc(data.id)
        .update(data.toMap());
  }

  static Future<void> deletedUser(UserResponse data) async {
    return await database
        .collection(Constants.users)
        .doc(data.id)
        .update({Constants.isDeleted: true});
  }

  static Future<String?> uploadFile(File file, String filename) async {
    final firebaseStorage = FirebaseStorage.instance;
    final Reference storageReference = firebaseStorage.ref().child(filename);
    Uint8List imageData = await file.readAsBytes();
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask;
    if (kIsWeb) {
      uploadTask = storageReference.putData(imageData, metadata);
    } else {
      uploadTask = storageReference.putFile(file);
    }

    await uploadTask.whenComplete(() => print('Upload complete'));
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  static Future<String?> uploadFileWeb(Uint8List file, String filename) async {
    final firebaseStorage = FirebaseStorage.instance;
    final Reference storageReference = firebaseStorage.ref().child(filename);
    final metadata = SettableMetadata(contentType: 'image/png');
    UploadTask uploadTask = storageReference.putData(file, metadata);
    await uploadTask.whenComplete(() => print('Upload complete'));
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  static Future<DocumentReference> newProduct(Product product) async {
    return database.collection(Constants.products).add(product.toMap());
  }

  static Future<QuerySnapshot> getAllProducts() async {
    return database
        .collection(Constants.products)
        .orderBy(Constants.sold, descending: true)
        .get();
  }

  static StreamSubscription listenProduct(
      {required Function(Product product) onModify,
      required Function(Product product) onDelete}) {
    return database.collection(Constants.products).snapshots().listen((event) {
      for (var type in event.docChanges) {
        if (type.type == DocumentChangeType.modified) {
          Product product =
              Product.fromDocument(type.doc.data() as Map<String, dynamic>);
          product.id = type.doc.id;
          onModify(product);
        } else if (type.type == DocumentChangeType.removed) {
          Product product =
              Product.fromDocument(type.doc.data() as Map<String, dynamic>);
          product.id = type.doc.id;
          onDelete(product);
        }
      }
    });
  }

  static Future<void> updateProduct(Product product) async {
    return database
        .collection(Constants.products)
        .doc(product.id)
        .update(product.toMap());
  }

  static Future<void> updateProductWarehouse(
      String id, int amount, int price) async {
    return database
        .collection(Constants.products)
        .doc(id)
        .update({Constants.amount: amount, Constants.priceInput: price});
  }

  static Future<void> updateAmountProduct(String id, int amount) async {
    return database
        .collection(Constants.products)
        .doc(id)
        .update({Constants.amount: amount});
  }

  static Future updateSoldProduct(String productId, int sold) async {
    return database
        .collection(Constants.products)
        .doc(productId)
        .update({Constants.sold: sold});
  }

  static Future<DocumentReference> newService(ServiceModel service) async {
    return database.collection(Constants.services).add(service.toMap());
  }

  static Future<QuerySnapshot> getAllServices() async {
    return database.collection(Constants.services).get();
  }

  static Future<DocumentReference> newWarehouse(Warehouse warehouse) async {
    return database.collection(Constants.warehouse).add(warehouse.toMap());
  }

  static Future<DocumentReference> addProductToWarehouse(
      Product item, String id) async {
    return database
        .collection(Constants.warehouse)
        .doc(id)
        .collection(Constants.products)
        .add(item.toMap());
  }

  static Future<QuerySnapshot> getAllCustomer() async {
    return database.collection(Constants.customers).get();
  }

  static Future<QuerySnapshot> getTypeProducts() async {
    return database.collection(Constants.typeProduct).get();
  }

  static Future<DocumentReference> newTypeProduct(String type) async {
    return database
        .collection(Constants.typeProduct)
        .add({Constants.type: type});
  }

  static Future<DocumentReference> newCustomer(UserResponse customer) async {
    return database.collection(Constants.customers).add(customer.toMap());
  }

  static Future<void> updateCustomer(int times, String id) async {
    return database
        .collection(Constants.customers)
        .doc(id)
        .update({Constants.times: times});
  }

  static Future<DocumentReference> newInvoice(Invoice invoice) async {
    return database.collection(Constants.invoices).add(invoice.toMap());
  }

  static Future<void> updateInvoice(Invoice invoice) {
    return database
        .collection(Constants.invoices)
        .doc(invoice.id!)
        .update(invoice.toMap());
  }

  static Future<void> newInvoiceProduct(
      Product product, String invoiceId) async {
    return database
        .collection(Constants.invoices)
        .doc(invoiceId)
        .collection(Constants.products)
        .doc(product.id)
        .set(product.toMap());
  }

  static Future<DocumentReference> newInvoiceService(
      ServiceModel serviceModel, String invoiceId) async {
    return database
        .collection(Constants.invoices)
        .doc(invoiceId)
        .collection(Constants.services)
        .add(serviceModel.toMapForInvoice());
  }

  static Future<QuerySnapshot> getAllInvoice() async {
    return database
        .collection(Constants.invoices)
        .orderBy(Constants.createdAt, descending: true)
        .get();
  }

  static Future<QuerySnapshot> getAllProductInInvoice(String docId) async {
    return database
        .collection(Constants.invoices)
        .doc(docId)
        .collection(Constants.products)
        .get();
  }

  static Future<QuerySnapshot> getAllServiceInInvoice(String docId) async {
    return database
        .collection(Constants.invoices)
        .doc(docId)
        .collection(Constants.services)
        .get();
  }

  static Future<void> addToCart(Product product, String userid) async {
    return database
        .collection(Constants.users)
        .doc(userid)
        .collection(Constants.carts)
        .doc(product.id)
        .set({Constants.amount: 1});
  }

  static Future<void> updateCart(
      Product product, String userId, int amount) async {
    return database
        .collection(Constants.users)
        .doc(userId)
        .collection(Constants.carts)
        .doc(product.id)
        .update({Constants.amount: amount});
  }

  static StreamSubscription listenCart(String userId,
      {required Function(List) listener}) {
    return database
        .collection(Constants.users)
        .doc(userId)
        .collection(Constants.carts)
        .snapshots()
        .listen((event) {
      listener(event.docs);
    });
  }

  static Future<DocumentSnapshot> getProductFromCart(String id, String userID) {
    return database
        .collection(Constants.users)
        .doc(userID)
        .collection(Constants.carts)
        .doc(id)
        .get();
  }

  static Future<QuerySnapshot> getAllProductFromCart(String userID) {
    return database
        .collection(Constants.users)
        .doc(userID)
        .collection(Constants.carts)
        .get();
  }

  static Future deleteProductFromCart(String userId, String productId) {
    return database
        .collection(Constants.users)
        .doc(userId)
        .collection(Constants.carts)
        .doc(productId)
        .delete();
  }

  static Future<DocumentSnapshot> getProductFromID(String id) {
    return database.collection(Constants.products).doc(id).get();
  }

  static Future<DocumentReference> newRoomCat(Room room) {
    return database.collection(Constants.roomCat).add(room.toMap());
  }

  static Future<DocumentReference> newRoomDog(Room room) {
    return database.collection(Constants.roomDog).add(room.toMap());
  }

  static Future<bool> isExistRoomCat(String name) async {
    bool isExist = false;
    await database
        .collection(Constants.roomCat)
        .where(Constants.name, isEqualTo: name)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isExist = true;
      }
    });
    return isExist;
  }

  static Future<bool> isExistRoomDog(String name) async {
    bool isExist = false;
    await database
        .collection(Constants.roomDog)
        .where(Constants.name, isEqualTo: name)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isExist = true;
      }
    });
    return isExist;
  }

  static Future<QuerySnapshot> getAllRoomCat() async {
    return database.collection(Constants.roomCat).orderBy(Constants.name).get();
  }

  static Future<QuerySnapshot> getAllRoomDog() async {
    return database.collection(Constants.roomDog).orderBy(Constants.name).get();
  }

  static Future bookRoomCat(Room room) async {
    return database
        .collection(Constants.roomCat)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future checkOutCat(Room room) async {
    return database
        .collection(Constants.roomCat)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future bookRoomDog(Room room) async {
    return database
        .collection(Constants.roomDog)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future checkOutDog(Room room) async {
    return database
        .collection(Constants.roomDog)
        .doc(room.id!)
        .update({Constants.isEmpty: room.isEmpty});
  }

  static Future<QuerySnapshot> getDiscountInDate(DateTime date) async {
    return database
        .collection(Constants.discounts)
        .where(Constants.toDate, isGreaterThanOrEqualTo: date)
        .get();
  }

  static StreamSubscription listenVoucher(DateTime date,
      {required Function(Voucher voucher) addEvent,
      required Function(Voucher voucher) modifyEvent,
      required Function(Voucher voucher) deleteEvent}) {
    return database
        .collection(Constants.vouchers)
        .orderBy(Constants.toDate, descending: true)
        .where(Constants.toDate, isGreaterThanOrEqualTo: date)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          if (change.doc.exists) {
            print('Đã thêm: ${change.doc.data()}');
            Voucher voucher = Voucher.fromMap(change.doc.data()!);
            voucher.id = change.doc.id;
            addEvent(voucher);
          }
        }
        if (change.type == DocumentChangeType.modified) {
          print('Đã sửa đổi: ${change.doc.data()}');
          Voucher voucher = Voucher.fromMap(change.doc.data()!);
          voucher.id = change.doc.id;
          modifyEvent(voucher);
        }
        if (change.type == DocumentChangeType.removed) {
          Voucher voucher = Voucher.fromMap(change.doc.data()!);
          voucher.id = change.doc.id;
          deleteEvent(voucher);
        }
      }
    });
  }

  static Future saveVoucher(Voucher voucher, String idUser) async {
    await database
        .collection(Constants.users)
        .doc(idUser)
        .collection(Constants.vouchers)
        .doc(voucher.id)
        .set(voucher.toMap());
  }

  static Future updateVoucher(int used, String voucherid) async {
    await database
        .collection(Constants.vouchers)
        .doc(voucherid)
        .update({Constants.used: used});
  }

  static Future<QuerySnapshot> getVoucherUser(
      String userid, DateTime date) async {
    return await database
        .collection(Constants.users)
        .doc(userid)
        .collection(Constants.vouchers)
        .where(Constants.toDate, isGreaterThanOrEqualTo: date)
        .get();
  }

  static Future<DocumentReference> newOrder(OrderModel order) async {
    return await database.collection(Constants.orders).add(order.toMap());
  }

  static Future addProductInOrder(Product product, String orderID) async {
    await database
        .collection(Constants.orders)
        .doc(orderID)
        .collection(Constants.products)
        .doc(product.id)
        .set(product.toMap());
  }

  static Future addCustomerInOrder(UserResponse user, String orderId) async {
    await database
        .collection(Constants.orders)
        .doc(orderId)
        .collection(Constants.customers)
        .doc(user.id)
        .set(user.toMap());
  }

  static Future addStaffInOrder(UserResponse user, String orderId) async {
    await database
        .collection(Constants.orders)
        .doc(orderId)
        .collection(Constants.staff)
        .doc(user.id)
        .set(user.toMap());
  }

  static Future addVoucherInOrder(Voucher voucher, String orderId) async {
    await database
        .collection(Constants.orders)
        .doc(orderId)
        .collection(Constants.vouchers)
        .doc(voucher.id)
        .set(voucher.toMap());
  }

  static Future deleteVoucherInUser(String voucherID, String userId) async {
    await database
        .collection(Constants.users)
        .doc(userId)
        .collection(Constants.vouchers)
        .doc(voucherID)
        .update({Constants.used: -10});
  }

  static Future deleteProductInCart(String userId, String productid) async {
    await database
        .collection(Constants.users)
        .doc(userId)
        .collection(Constants.carts)
        .doc(productid)
        .delete();
  }

  static StreamSubscription listenRoomCat(
      {required Function(Room room) onAdded,
      required Function(Room room) onModified,
      required Function(Room room) onRemoved}) {
    return database
        .collection(Constants.roomCat)
        .orderBy(Constants.name)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Room room =
              Room.fromDocument(change.doc.data() as Map<String, dynamic>);
          room.id = change.doc.id;
          onAdded(room);
        } else if (change.type == DocumentChangeType.modified) {
          Room room =
              Room.fromDocument(change.doc.data() as Map<String, dynamic>);
          room.id = change.doc.id;
          onModified(room);
        } else if (change.type == DocumentChangeType.removed) {
          Room room =
              Room.fromDocument(change.doc.data() as Map<String, dynamic>);
          room.id = change.doc.id;
          onRemoved(room);
        }
      }
    });
  }

  static StreamSubscription listenRoomDog(
      {required Function(Room room) onAdded,
      required Function(Room room) onModified,
      required Function(Room room) onRemoved}) {
    return database
        .collection(Constants.roomDog)
        .orderBy(Constants.name)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Room room =
              Room.fromDocument(change.doc.data() as Map<String, dynamic>);
          room.id = change.doc.id;
          onAdded(room);
        } else if (change.type == DocumentChangeType.modified) {
          Room room =
              Room.fromDocument(change.doc.data() as Map<String, dynamic>);
          room.id = change.doc.id;
          onModified(room);
        } else if (change.type == DocumentChangeType.removed) {
          Room room =
              Room.fromDocument(change.doc.data() as Map<String, dynamic>);
          room.id = change.doc.id;
          onRemoved(room);
        }
      }
    });
  }

  static StreamSubscription listenOrder(String userId,
      {required Function(OrderModel order) onAdded,
      required Function(OrderModel order) onModified,
      required Function(OrderModel order) onRemoved}) {
    return database
        .collection(Constants.orders)
        .where(Constants.customerId)
        .orderBy(Constants.createdAt, descending: true)
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          OrderModel order =
              OrderModel.fromMap(change.doc.data() as Map<String, dynamic>);
          order.id = change.doc.id;
          order.product = [];
          onAdded(order);
        } else if (change.type == DocumentChangeType.modified) {
          OrderModel order =
              OrderModel.fromMap(change.doc.data() as Map<String, dynamic>);
          order.id = change.doc.id;
          print('modifed: ${change.doc.data()}');
          onModified(order);
        } else if (change.type == DocumentChangeType.removed) {
          OrderModel order =
              OrderModel.fromMap(change.doc.data() as Map<String, dynamic>);
          order.id = change.doc.id;
          onRemoved(order);
        }
      }
    });
  }

  static Future<QuerySnapshot> getProductFromOrder(String orderid) async {
    return database
        .collection(Constants.orders)
        .doc(orderid)
        .collection(Constants.products)
        .get();
  }

  static Future<QuerySnapshot> getStaffFromOrder(String orderid) async {
    return database
        .collection(Constants.orders)
        .doc(orderid)
        .collection(Constants.staff)
        .get();
  }

  static Future updateStatusOrder(String idOrder, String status) async {
    return database
        .collection(Constants.orders)
        .doc(idOrder)
        .update({Constants.status: status});
  }

  static Future<QuerySnapshot> getVoucherFromOrder(String orderid) async {
    return database
        .collection(Constants.orders)
        .doc(orderid)
        .collection(Constants.vouchers)
        .get();
  }

  static Future changePassword(String password, String userId) async {
    return database
        .collection(Constants.users)
        .doc(userId)
        .update({Constants.password: password});
  }

  static Future<void> updateToken(String token, String userId) async {
    await database
        .collection(Constants.users)
        .doc(userId)
        .update({Constants.token: token});
  }
}

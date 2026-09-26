import 'package:flutter/material.dart';

// Data Models
class Product {
  final String id;
  String name;
  String description;
  double price;
  int stock;
  String? imagePath;

  Product({required this.id, required this.name, required this.description, required this.price, required this.stock, this.imagePath});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Order {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime date;
  final String fullName;
  final String address;
  final String city;
  final String postalCode;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.date,
    required this.fullName,
    required this.address,
    required this.city,
    required this.postalCode,
  });
}

class ShoppingCart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(0, (total, item) => total + (item.product.price * item.quantity));

  void addItem(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class Service {
  String name;
  String description;
  double price;

  Service({required this.name, required this.description, required this.price});
}

class Appointment {
  final String serviceName;
  final DateTime date;
  final TimeOfDay time;
  final String? notes;

  Appointment({required this.serviceName, required this.date, required this.time, this.notes});
}

// App Data
class AppData extends ChangeNotifier {
  final List<Product> _products = [
    Product(id: '1', name: 'Dog Food', description: 'High-quality dog food for your furry friend.', price: 25.99, stock: 10),
    Product(id: '2', name: 'Cat Food', description: 'Nutritious food for your feline companion.', price: 22.50, stock: 15),
    Product(id: '3', name: 'Toys', description: 'Fun toys to keep your pet entertained.', price: 15.00, stock: 20),
  ];

  final List<Service> _services = [
    Service(name: 'Grooming', description: 'Complete grooming services for your pet.', price: 55.00),
    Service(name: 'Veterinary Services', description: "Expert veterinary care for your pet's health.", price: 120.00),
    Service(name: 'Pet Boarding', description: 'Safe and comfortable boarding facilities.', price: 45.00),
  ];

  final List<Appointment> _appointments = [];
  final ShoppingCart _cart = ShoppingCart();
  final List<Order> _orders = [];

  List<Product> get products => _products;
  List<Service> get services => _services;
  List<Appointment> get appointments => _appointments;
  ShoppingCart get cart => _cart;
  List<Order> get orders => _orders;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(int index, Product product) {
    _products[index] = product;
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  void updateServicePrice(int index, double newPrice) {
    _services[index].price = newPrice;
    notifyListeners();
  }

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    cart.clearCart();
    notifyListeners();
  }
}

final AppData appData = AppData();

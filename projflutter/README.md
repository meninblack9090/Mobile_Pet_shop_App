# FurCare

FurCare is a comprehensive Flutter application designed for a pet care business. It allows users to browse and purchase 
products, manage their cart, and viewpet products, book pet services like grooming and boarding, and manage their orders.
The app also includes a full-featured admin panel for managing products, services, and viewing sales reports.

## Getting Started

This project is a starting point for a Flutter application. To get started, you will need to have the Flutter SDK installed on your machine.

### Setup

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    cd projflutter
    ```

2.  **Install dependencies:**
    This project uses a few key packages. Make sure you have the following in your `pubspec.yaml` and run `flutter pub get`:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      google_fonts: ^6.1.0
      image_picker: ^1.0.4
      intl: ^0.19.0
      path: ^1.8.3
      path_provider: ^2.0.15
    ```
    Install them by running:
    ```sh
    flutter pub get
    ```

3.  **Run the application:**
    ```sh
    flutter run
    ```

## Usage Guide

Once the app is running, you can explore its features as both a regular user and an admin.

### User Guide

1.  **Login:** Start by logging into the application.
2.  **Browse Store:** Navigate to the "Store" tab to see a list of available products. You can tap on any product to view its details, including price, stock, and description.
3.  **Manage Cart:** From the product detail page, you can add items to your cart. Access the cart by tapping the shopping cart icon in the top app bar.
4.  **Checkout:** From the cart, you can proceed to checkout, fill in your shipping details, and place an order.
5.  **View Services:** Go to the "Services" tab to see available pet care services like Grooming and Pet Boarding. You can book an appointment for these services directly from the app.
6.  **Order History:** Check the status and details of your past orders by tapping the history icon on the home page.

### Admin Guide

1.  **Access Admin Panel:** From the home page, tap the admin icon in the app bar to access the Admin Panel.
2.  **Manage Products:**
    *   **Add:** Tap the "Add Product" button to open a dialog where you can enter the product's name, description, price, and stock.
    *   **Upload Image:** Use the "Upload Image" button within the dialog to select a photo from your device. A preview will be shown.
    *   **Edit:** Tap the pencil icon next to any product to modify its details.
    *   **Delete:** Tap the trash can icon to remove a product from the store.
3.  **Manage Services:**
    *   You can edit the price of services by tapping the pencil icon next to the service name.
4.  **View Reports:** The "Report" tab provides a simple overview of sales performance.

# 🛒 Flutter + Node.js Shopping App Nmae BAJAAR

A full-stack **e-commerce application** built with Flutter for the frontend and Node.js + Express + MongoDB for the backend. It supports **user authentication**, **product management**, **cart**, **order placement**, **role-based access (admin, user, superuser)**, **checkout with dummy payment**, and **order tracking**.

---

## 📱 Frontend: Flutter App

### 💡 Screens & Features

#### 🔐 **Authentication**
- **Register/Login** with role assignment (user/admin)
- JWT-based login token handling
- Stored using Shared Preferences

#### 🏠 **Home Page**
- Shows a list of all available products
- Product cards include image, title, price, and "Add to Cart" button
- Integrated search bar for filtering

#### 📦 **Product Detail Page**
- Detailed product info: image, title, price, description
- Options to **Add to Cart** or **Buy Now**
- Suggested related products (same category)

#### 🛒 **Cart Page**
- Shows all selected items
- Allows quantity adjustment or item removal
- Calculates total price
- Proceeds to checkout

#### 👤 **Profile Page**
- View user information (name, email, role)
- Edit and update shipping address
- See user-specific past orders

#### 💳 **Checkout Page**
- Displays cart summary and address
- Validates address before proceeding
- Navigates to payment page

#### 💰 **Payment Page**
- Dummy payment integration
  - **Card**: accepts 16-digit format
  - **UPI**: validates UPI format (e.g. name@bank)
- Simulates success/failure
- Saves order to backend and clears local cart

#### 📦 **Orders Page**
- Users: See their orders
- Admins: See all orders and change status

#### 🔍 **Search & Filter**
- Filter products by name/category
- Real-time search integrated in Home Page

---

## 👥 Roles & Access Control

| Role        | Capabilities                                                                 |
|-------------|------------------------------------------------------------------------------|
| `user`      | Can register, login, view/buy products, manage cart, checkout, and view orders |
| `admin`     | Can do everything user can + manage (add/edit/delete) products, view all orders |
| `superuser` | Optional future enhancement (can manage users/admins)                        |

---

## 🧰 Tech Stack

| Layer       | Technology                            |
|------------|----------------------------------------|
| Frontend   | Flutter, Dart, Shared Preferences      |
| Backend    | Node.js, Express                       |
| Database   | MongoDB (via Mongoose ODM)             |
| Auth       | JWT + Bcrypt                           |
| Storage    | Local Storage (Flutter SharedPreferences) |
| API Comm   | `http` package in Flutter              |

---

## 🧱 Project Structure

### 🔙 Backend

backend/
    │   ├── index.js
    │   ├── package.json
    │   ├── requirements.txt
    │   ├── config/
    │   │   ├── db.js
    │   │   ├── env.js
    │   │   └── jwt.js
    │   ├── controllers/
    │   │   ├── authController.js
    │   │   ├── orderController.js
    │   │   ├── paymentController.js
    │   │   └── productController.js
    │   ├── middlewares/
    │   │   ├── auth.js
    │   │   ├── errorHandler.js
    │   │   ├── upload.js
    │   │   └── validate.js
    │   ├── models/
    │   │   ├── Cart.js
    │   │   ├── Order.js
    │   │   ├── Payment.js
    │   │   ├── Product.js
    │   │   └── User.js
    │   ├── routes/
    │   │   ├── authRoutes.js
    │   │   ├── orderRoutes.js
    │   │   ├── paymentRoutes.js
    │   │   └── productRoutes.js
    │   └── utils/
    │       ├── generateOrderId.js
    │       ├── jwt.js
    │       ├── logger.js
    │       ├── multer.js
    │       └── sendEmail.js




    
### 📱 Frontend

project_files/
        └── amazon_soc/
            ├── README.md
            ├── analysis_options.yaml
            ├── pubspec.lock
            ├── pubspec.yaml
            ├── .metadata
            ├── android/
            │   ├── build.gradle.kts
            │   ├── gradle.properties
            │   ├── settings.gradle.kts
            │   ├── app/
            │   │   ├── build.gradle.kts
            │   │   └── src/
            │   │       ├── debug/
            │   │       │   └── AndroidManifest.xml
            │   │       ├── main/
            │   │       │   ├── AndroidManifest.xml
            │   │       │   ├── kotlin/
            │   │       │   │   └── com/
            │   │       │   │       └── example/
            │   │       │   │           └── amazon_soc/
            │   │       │   │               └── MainActivity.kt
            │   │       │   └── res/
            │   │       │       ├── drawable/
            │   │       │       │   └── launch_background.xml
            │   │       │       ├── drawable-v21/
            │   │       │       │   └── launch_background.xml
            │   │       │       ├── values/
            │   │       │       │   └── styles.xml
            │   │       │       ├── values-night/
            │   │       │       │   └── styles.xml
            │   │       │       └── xml/
            │   │       │           └── provider_paths.xml
            │   │       └── profile/
            │   │           └── AndroidManifest.xml
            │   └── gradle/
            │       └── wrapper/
            │           └── gradle-wrapper.properties
            ├── ios/
            │   ├── Flutter/
            │   │   ├── AppFrameworkInfo.plist
            │   │   ├── Debug.xcconfig
            │   │   └── Release.xcconfig
            │   ├── Runner/
            │   │   ├── AppDelegate.swift
            │   │   ├── Info.plist
            │   │   ├── Runner-Bridging-Header.h
            │   │   ├── Assets.xcassets/
            │   │   │   ├── AppIcon.appiconset/
            │   │   │   │   └── Contents.json
            │   │   │   └── LaunchImage.imageset/
            │   │   │       ├── README.md
            │   │   │       └── Contents.json
            │   │   └── Base.lproj/
            │   │       ├── LaunchScreen.storyboard
            │   │       └── Main.storyboard
            │   └── RunnerTests/
            │       └── RunnerTests.swift
            ├── lib/
            │   ├── main.dart
            │   ├── models/
            │   │   ├── auth_model.dart
            │   │   ├── order_model.dart
            │   │   └── product_model.dart
            │   ├── pages/
            │   │   ├── add_product_page.dart
            │   │   ├── cart_page.dart
            │   │   ├── orders_page.dart
            │   │   ├── profile_page.dart
            │   │   └── product/
            │   │       ├── edit_product_page.dart
            │   │       └── your_products_page.dart
            │   ├── providers/
            │   │   └── cart_provider.dart
            │   ├── screens/
            │   │   ├── admin_register_page.dart
            │   │   ├── checkout_page.dart
            │   │   ├── home_page.dart
            │   │   ├── login_page.dart
            │   │   ├── payment_page.dart
            │   │   ├── product_detail_page.dart
            │   │   ├── register_page.dart
            │   │   ├── update_profile_page.dart
            │   │   └── welcome_page.dart
            │   ├── services/
            │   │   ├── auth_service.dart
            │   │   ├── order_service.dart
            │   │   └── product_service.dart
            │   ├── utils/
            │   │   ├── local_storage.dart
            │   │   ├── root_app.dart
            │   │   └── user_provider.dart
            │   └── widgets/
            │       ├── custom_button.dart
            │       ├── custom_textfield.dart
            │       ├── product_card.dart
            │       └── product_search_bar.dart
            ├── linux/
            │   ├── CMakeLists.txt
            │   ├── flutter/
            │   │   ├── CMakeLists.txt
            │   │   ├── generated_plugin_registrant.cc
            │   │   ├── generated_plugin_registrant.h
            │   │   └── generated_plugins.cmake
            │   └── runner/
            │       ├── CMakeLists.txt
            │       ├── main.cc
            │       ├── my_application.cc
            │       └── my_application.h
            ├── macos/
            │   ├── Flutter/
            │   │   ├── Flutter-Debug.xcconfig
            │   │   ├── Flutter-Release.xcconfig
            │   │   └── GeneratedPluginRegistrant.swift
            │   ├── Runner/
            │   │   ├── AppDelegate.swift
            │   │   ├── DebugProfile.entitlements
            │   │   ├── Info.plist
            │   │   ├── MainFlutterWindow.swift
            │   │   ├── Release.entitlements
            │   │   ├── Assets.xcassets/
            │   │   │   └── AppIcon.appiconset/
            │   │   │       └── Contents.json
            │   │   ├── Base.lproj/
            │   │   │   └── MainMenu.xib
            │   │   └── Configs/
            │   │       ├── AppInfo.xcconfig
            │   │       ├── Debug.xcconfig
            │   │       ├── Release.xcconfig
            │   │       └── Warnings.xcconfig
            │   └── RunnerTests/
            │       └── RunnerTests.swift
            ├── test/
            │   └── widget_test.dart
            ├── web/
            │   ├── index.html
            │   └── manifest.json
            └── windows/
                ├── CMakeLists.txt
                ├── flutter/
                │   ├── CMakeLists.txt
                │   ├── generated_plugin_registrant.cc
                │   ├── generated_plugin_registrant.h
                │   └── generated_plugins.cmake
                └── runner/
                    ├── CMakeLists.txt
                    ├── flutter_window.cpp
                    ├── flutter_window.h
                    ├── main.cpp
                    ├── resource.h
                    ├── runner.exe.manifest
                    ├── Runner.rc
                    ├── utils.cpp
                    ├── utils.h
                    ├── win32_window.cpp
                    └── win32_window.h





---

## 📡 API Endpoints

### 🔐 Auth/User

| Method | Endpoint               | Access   | Description                        |
|--------|------------------------|----------|------------------------------------|
| POST   | `/api/users/register`  | Public   | Register a new user/admin          |
| POST   | `/api/users/login`     | Public   | Login and get JWT token            |
| GET    | `/api/users/profile`   | Private  | Get logged-in user profile         |
| PUT    | `/api/users/address`   | Private  | Update user's shipping address     |

---

### 🛍️ Products

| Method | Endpoint                 | Access     | Description                       |
|--------|--------------------------|------------|-----------------------------------|
| GET    | `/api/products`          | Public     | Get all products                  |
| GET    | `/api/products/:id`      | Public     | Get a single product              |
| POST   | `/api/products`          | AdminOnly  | Create a new product              |
| PUT    | `/api/products/:id`      | AdminOnly  | Update a product                  |
| DELETE | `/api/products/:id`      | AdminOnly  | Delete a product                  |

---

### 📦 Orders

| Method | Endpoint                   | Access     | Description                          |
|--------|----------------------------|------------|--------------------------------------|
| POST   | `/api/orders`              | Private    | Place an order                       |
| GET    | `/api/orders/my`           | Private    | Get user's order history             |
| GET    | `/api/orders/admin`        | AdminOnly  | Admin fetches all user orders        |
| PUT    | `/api/orders/:id/status`   | AdminOnly  | Admin updates order delivery status  |

---

## ⚙️ Setup Instructions

### 🔙 Backend

```bash
cd backend
npm install


```
### make a .env file and put below content
MONGO_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret

```bash
node server.js
```

##  For frontend

```bash
flutter pub get
flutter run
```

## 🛣️ Data Flow Summary
User registers/login → token stored locally

On login, products fetched and shown on Home

User adds to cart → stored in local storage

On Checkout → address is validated

Payment → dummy simulation

Order posted to backend and cart is cleared

User/Admin can view orders

Admin can manage products and order status



## 💡 Future Enhancements
🔐 OAuth login (Google, GitHub)

🧾 Payment Gateway (Razorpay/Stripe)

🖼️ Upload & manage product images via Cloudinary or Firebase

🛎️ Push notifications (Flutter + Firebase)

🧑‍🤝‍🧑 Superuser management panel

📦 Product inventory tracking

📊 Admin dashboard with sales analytics

🧪 Unit & integration testing for Flutter and Node

🌐 Deploy backend on Render / Railway

📲 Deploy app to Play Store


# 🧑‍💻 Author
Made with ❤️ by Rahul

Flutter + Node.js based Shopping App
Fully role-based, order-supported, and payment-simulated e-commerce solution

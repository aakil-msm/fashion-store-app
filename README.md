# F-Dilu Fashion Store 🛍️

A complete, production-ready Flutter e-commerce fashion app — **F-Dilu Fashion Store** — built with clean architecture, responsive layouts, and a polished UI.

---

## 📱 Screenshots Overview

| Splash | Login | Home | Products |
|--------|-------|------|----------|
| Animated brand splash | Tab-based login/register | Banner + categories + grid | Grid & list view with sort |

| Product Detail | Cart | Checkout | Profile |
|----------------|------|----------|---------|
| Image, size, color picker | Swipe-to-delete items | 3-step wizard | Stats, settings, menu |

---

## ✅ Screens Implemented

| Screen | File | Features |
|--------|------|----------|
| **Splash** | `splash_screen.dart` | Animated logo, auto-navigate to Login after 3s |
| **Login / Register** | `login_screen.dart` | Tab-based, form validation, social login buttons |
| **Home** | `home_screen.dart` | Banner carousel, category chips, featured grid, new arrivals row |
| **Product Listing** | `product_listing_screen.dart` | Grid/list toggle, sort (price, rating), product count |
| **Product Details** | `product_details_screen.dart` | Gallery, size/color picker, quantity, add to cart, buy now |
| **Cart** | `cart_screen.dart` | Swipe-to-delete, qty controls, price summary, promo discount |
| **Checkout** | `checkout_screen.dart` | 3-step wizard: Shipping → Payment → Review → Success dialog |
| **Profile** | `profile_screen.dart` | Avatar, order stats, notification toggle, menu items, logout |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── product.dart               # Product data model (from FakeStore API)
│   └── cart_item.dart             # CartItem model with quantity
├── screens/
│   ├── splash_screen.dart         # Animated splash screen
│   ├── login_screen.dart          # Login & Registration
│   ├── main_nav_screen.dart       # Bottom nav shell (IndexedStack)
│   ├── home_screen.dart           # Home with banner, categories, products
│   ├── product_listing_screen.dart # Browse all/category products
│   ├── product_details_screen.dart # Full product detail view
│   ├── cart_screen.dart           # Shopping cart
│   ├── checkout_screen.dart       # Multi-step checkout (UI only)
│   └── profile_screen.dart        # User profile & settings
├── utils/
│   ├── app_constants.dart         # AppColors, AppStrings
│   ├── api_service.dart           # HTTP calls to FakeStore API
│   └── cart_provider.dart         # ChangeNotifier cart state
└── widgets/
    └── product_card.dart          # Reusable product grid card
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.6
- Dart SDK >= 3.0.6
- Android Studio / VS Code with Flutter extension

### Setup

```bash
# Clone or unzip the project
cd fdilu_fashion_store

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS (requires macOS + Xcode)
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `http` | REST API calls to FakeStore API |
| `google_fonts` | Typography |
| `cupertino_icons` | iOS-style icons |

> No Firebase. No state management package. Uses `ChangeNotifier` + built-in Flutter state.

---

## 🌐 API

Products are fetched from the public **[FakeStore API](https://fakestoreapi.com)**:

- `GET /products` — All products
- `GET /products/category/{category}` — By category

Categories: `women's clothing`, `men's clothing`, `jewelery`, `electronics`

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#1A1A2E` (dark navy) |
| Accent | `#E94560` (fashion red) |
| Secondary | `#16213E` |
| Background | `#F8F9FA` |
| Gold (stars) | `#FFD700` |

---

## 🏗️ Architecture

- **No Firebase** — as required
- **Clean separation**: models / screens / widgets / utils
- **Navigation**: `Navigator.push` for detail screens, `IndexedStack` for bottom nav
- **State**: `StatefulWidget` + local state; `CartProvider` extends `ChangeNotifier` (ready for `provider` package)
- **Responsive**: Uses `MediaQuery`, `Expanded`, `Flexible`, `ListView`, `GridView`

---

## 📋 Flutter Requirements Checklist

- ✅ All 7+ screens implemented
- ✅ Navigation between all screens
- ✅ Responsive layouts (works on phones and tablets)
- ✅ Clean project structure (models / screens / widgets / utils)
- ✅ No Firebase integration
- ✅ Form validation (login & register)
- ✅ Pull-to-refresh on Home
- ✅ Loading states with indicators
- ✅ Error handling with retry
- ✅ Animated splash screen
- ✅ App branding: **F-Dilu Fashion Store** throughout

---

## 👤 Author

Built for **F-Dilu Fashion Store** — Style Redefined.

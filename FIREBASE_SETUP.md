# Firebase Setup Instructions — F-Dilu Fashion Store

This document explains how to connect the F-Dilu Fashion Store Flutter
application to Firebase so that authentication, the product catalogue, the
shopping cart, and order history all function correctly.

The app uses three Firebase services:

- **Firebase Authentication** — email/password sign-in
- **Cloud Firestore** — products, users, carts, and orders
- **Firebase Core** — required to initialise Firebase in the app

---

## 1. Prerequisites

Make sure the following are installed before starting:

- Flutter SDK (3.0 or newer) — verify with `flutter --version`
- Node.js — required for the Firebase CLI
- A Google account (to access the Firebase Console)

Install the two command-line tools used to link Firebase to Flutter:

```bash
# Firebase CLI
npm install -g firebase-tools

# Log in to your Google account
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli
```

If the `flutterfire` command is not found afterwards, add the Dart pub cache
`bin` folder to your system PATH:

- Windows: `%USERPROFILE%\AppData\Local\Pub\Cache\bin`
- macOS / Linux: `$HOME/.pub-cache/bin`

---

## 2. Create the Firebase Project

1. Go to the Firebase Console: <https://console.firebase.google.com>
2. Click **Add project**.
3. Name the project (for example `fdilu-fashion-store`).
4. Google Analytics is not required and can be disabled.
5. Click **Create project** and wait for it to finish.

---

## 3. Enable Authentication

1. In the Firebase Console, open **Build → Authentication**.
2. Click **Get started**.
3. Open the **Sign-in method** tab.
4. Select **Email/Password**, enable it, and click **Save**.

---

## 4. Create the Firestore Database

1. In the Firebase Console, open **Build → Firestore Database**.
2. Click **Create database**.
3. Choose **Start in test mode** (the security rules are tightened later in
   step 7).
4. Select a region close to you (for example `asia-south1`).
5. Click **Enable**.

---

## 5. Link Firebase to the Flutter App

Open a terminal in the project root (the folder that contains
`pubspec.yaml`) and run:

```bash
flutterfire configure
```

When prompted:

- Select the Firebase project created in step 2.
- Select the **android** platform (and **ios** if building for iOS).

This command automatically:

- generates `lib/firebase_options.dart`
- registers the app with Firebase
- downloads `google-services.json` into `android/app/`

Then install the project dependencies:

```bash
flutter pub get
```

The required Firebase packages are already declared in `pubspec.yaml`:

```yaml
firebase_core: ^2.27.0
firebase_auth: ^4.17.8
cloud_firestore: ^4.15.8
```

---

## 6. Seed the Product Catalogue

The coursework requires products to be pre-loaded into Firestore. The project
includes a one-time seed routine in `lib/utils/seed_service.dart`.

**Step 6.1** — Temporarily allow writes. In the Firebase Console open
**Firestore → Rules**, replace the rules with the following, and click
**Publish**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Step 6.2** — Add the seed call. In `lib/main.dart`, add the import and the
seed call just after `Firebase.initializeApp(...)`:

```dart
import 'utils/seed_service.dart';

// inside main(), after initializeApp:
await SeedService.seedProducts();
```

**Step 6.3** — Run the app once:

```bash
flutter run
```

The debug console will show:

```
[SeedService] Seeding 20 products into Firestore...
[SeedService] Done! 20 products written to Firestore.
```

**Step 6.4** — Remove the `SeedService.seedProducts()` line from `main.dart`
so the app does not re-seed on every launch.

---

## 7. Apply the Firestore Security Rules

After seeding, replace the temporary rules with the final secure rules. In the
Firebase Console open **Firestore → Rules**, paste the following, and click
**Publish**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Products are readable by anyone, not writable from the client
    match /products/{productId} {
      allow read: if true;
      allow write: if false;
    }

    // Each user can only access their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }

    // Orders belong to the owning user only
    match /users/{userId}/orders/{orderId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }

    // Cart belongs to the owning user only
    match /users/{userId}/cart/{itemId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

---

## 8. Run the Application

```bash
flutter clean
flutter pub get
flutter run
```

To verify the setup is working:

1. Register a new account on the login screen.
2. In the Firebase Console, check **Authentication → Users** — the new user
   should be listed.
3. In **Firestore → Data**, confirm the `products` collection has 20
   documents and the `users` collection has a document for the new user.
4. Add items to the cart, place an order, and confirm that `cart` and
   `orders` sub-collections appear under the user document.

---

## Firestore Data Structure Reference

```
products/{autoId}
    title        : String
    description  : String
    price        : Number
    category     : String   ("women's clothing" | "men's clothing" | "accessories")
    imageAsset   : String   (e.g. "images/products/im1.png")
    ratingRate   : Number
    ratingCount  : Number

users/{uid}
    name         : String
    email        : String
    phone        : String
    address      : String
    createdAt    : Timestamp

users/{uid}/cart/{itemId}
    productId, title, price, imageAsset, quantity, size, color, ...

users/{uid}/orders/{orderId}
    deliveryName, deliveryPhone, deliveryAddress
    paymentMethod, subtotal, shipping, total
    status, createdAt
    items        : Array of ordered products
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `permission-denied` while seeding | The temporary open rules in step 6.1 were not published. |
| Products do not appear | The seed routine has not been run, or it was removed before running once. |
| `flutterfire` command not found | Add the Dart pub cache `bin` folder to PATH (see step 1). |
| Build fails after adding Firebase | Run `flutter clean`, then `flutter pub get`, then rebuild. |

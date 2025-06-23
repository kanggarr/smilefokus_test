# smilefokus_test

A Flutter application for displaying and managing reward items. Users can view available rewards, save them to a wishlist, and redeem items based on their available points.

---

## Getting Started

### 📋 Prerequisites

Before running this app, make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Recommended: version ≥ 3.10.0)
- Dart SDK (included with Flutter)
- An IDE like **VS Code** or **Android Studio**
- A connected device or emulator for testing

---

### How to Build and Run

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/smilefokus_test.git
   cd smilefokus_test
   ```

2. **Get Flutter packages:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```

   > You can also run the app from your IDE using the "Run" or "Start Debugging" button.

---

## Features

- Display a grid of reward items (2 columns)
- Toggle favorite status to add/remove rewards from the wishlist
- View reward detail page with image, name, description, and required points
- Redeem rewards:
  - If the user has enough points, a confirmation dialog will appear
  - Points are deducted after successful redemption
  - Redeem button is disabled if the user has insufficient points
- Wishlist page shows only saved items and updates immediately when items are unsaved

---

## Project Structure

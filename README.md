# Waste2Worth ✨

An IoT-based smart composting solution designed to transform food waste into valuable compost while promoting sustainability. Waste2Worth helps monitor composting conditions, provides actionable notifications, and connects users to a marketplace for selling and buying compost manure.

---

## 🚀 Features

1. **Smart Compost Monitoring**:
   - Tracks temperature, humidity, pH, and gas levels using IoT sensors.
   - Real-time notifications guide users to take necessary actions.

2. **Marketplace Integration**:
   - Users can list or purchase compost manure.
   - Secure **payment integration** via **eSewa** for seamless transactions.
   - Interactive maps show nearby sellers and their details.

3. **Actionable Composting Tips**:
   - Provides recommendations like adding soil, dry leaves, or adjusting moisture for proper aerobic composting.

4. **Location Awareness**:
   - Fetches live user location and dynamically updates maps to display sellers near the user.
   - **Geocoding support** to convert latitude/longitude into readable addresses.

5. **User-Friendly UI**:
   - Clean dashboard to display composting progress and sensor readings.
   - **Lottie animations** for an enhanced user experience.
   - Seamless navigation between features.
   - Custom **Poppins font** for better typography and readability.

---

## 📊 Screenshots
_Add screenshots of the app to showcase its UI/UX (e.g., dashboard, map, marketplace)._ 

---

## 🛠️ Tech Stack

- **Flutter**: For cross-platform mobile app development.
- **Firebase**: Backend services for authentication, database, and notifications.
- **Geolocator**: To fetch live user location.
- **OpenStreetMap**: For map integration using the `flutter_map` package.
- **Geocoding**: Converts coordinates to addresses for better location identification.
- **eSewa SDK**: Payment integration for compost transactions.
- **Lottie**: Animated UI elements for improved user experience.
- **Dart**: Programming language for app logic.

---

## 🔧 Setup Instructions

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Set up an editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).
- Enable location services on your testing device.

### Steps to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/Waste2Worth.git
   cd Waste2Worth
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. Ensure location permissions are granted for the app on your device.

---

## 🌐 Deployment

### Android Deployment:
1. Generate a signed APK:
   ```bash
   flutter build apk --release
   ```
2. Locate the APK in the `build/app/outputs/flutter-apk` directory.
3. Distribute the APK or upload it to the Play Store following [this guide](https://developer.android.com/studio/publish).

### iOS Deployment:
1. Archive the app in Xcode by opening the iOS project.
2. Follow [Apple’s deployment process](https://developer.apple.com/app-store/) to distribute it on the App Store.

---

## 📈 Future Scope

1. **AI Integration**:
   - Use AI models to predict compost readiness and quality based on sensor data trends.

2. **Gamification**:
   - Reward users for consistent composting and eco-friendly practices.

3. **Expanded Marketplace**:
   - Introduce bulk purchase options and additional eco-products.

4. **Community Composting**:
   - Allow neighborhoods to collaboratively compost and share resources.

5. **Carbon Footprint Tracking**:
   - Help users measure their contribution to reducing landfill waste and methane emissions.

---

## 🛡️ Security

- Firebase Security Rules are implemented to restrict database access.
- Firebase App Check ensures only verified apps can access backend resources.
- API keys are restricted by domain and platform to prevent unauthorized usage.


---

## 📧 Contact

For queries, reach out at: **dhirajkrchaurasiya@gmail.com**

---

## 👫 Authors

- **Dhiraj Chaurasiya**
- Collaborators will appear here!

---

## 📊 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit changes:
   ```bash
   git commit -m "Add some feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Create a pull request on GitHub.

---

## 🎮 Fun Fact

This app was initially named **FireFlutter** locally because it's created using **Flutter and Firebase**.

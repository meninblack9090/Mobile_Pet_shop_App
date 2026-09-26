# How to Run Flutter App on Your Phone

## Method 1: USB Debugging (Recommended)

### Step 1: Enable Developer Options on Android
1. Go to **Settings** → **About Phone**
2. Find **Build Number** and tap it **7 times**
3. You'll see a message: "You are now a developer!"

### Step 2: Enable USB Debugging
1. Go to **Settings** → **Developer Options** (or **System** → **Developer Options**)
2. Enable **USB Debugging**
3. Enable **Install via USB** (if available)

### Step 3: Connect Your Phone
1. Connect your phone to your computer via USB cable
2. On your phone, you'll see a prompt: "Allow USB debugging?"
3. Check **"Always allow from this computer"** and tap **OK**

### Step 4: Verify Connection
Open terminal/command prompt and run:
```bash
flutter devices
```
You should see your phone listed (e.g., "sdk gphone64 arm64" or your device model)

### Step 5: Run the App
```bash
flutter run
```
The app will be installed and launched on your phone automatically!

---

## Method 2: Build APK and Install Manually

### Step 1: Build the APK
```bash
flutter build apk
```

### Step 2: Find the APK
The APK will be located at:
```
build\app\outputs\flutter-apk\app-release.apk
```

### Step 3: Transfer to Phone
- Copy the APK file to your phone (via USB, email, cloud storage, etc.)

### Step 4: Install on Phone
1. On your phone, go to **Settings** → **Security**
2. Enable **Install from Unknown Sources** (or **Install Unknown Apps** for specific apps)
3. Open the APK file on your phone
4. Tap **Install**

---

## Method 3: Wireless Debugging (Android 11+)

### Step 1: Enable Wireless Debugging
1. Connect phone via USB first
2. Go to **Settings** → **Developer Options**
3. Enable **Wireless debugging**
4. Tap **Wireless debugging** → **Pair device with pairing code**
5. Note the IP address and port (e.g., 192.168.1.100:12345)

### Step 2: Connect Wirelessly
On your computer, run:
```bash
adb connect <IP_ADDRESS>:<PORT>
```
Example: `adb connect 192.168.1.100:12345`

### Step 3: Run the App
```bash
flutter run
```

---

## Troubleshooting

### Phone Not Detected?
1. Make sure USB debugging is enabled
2. Try a different USB cable
3. Try a different USB port
4. Install/update USB drivers for your phone
5. Run `adb devices` to check if ADB sees your device

### Permission Denied?
- Make sure you allowed USB debugging on your phone
- Try revoking USB debugging authorizations in Developer Options and reconnect

### Build Errors?
- Make sure you have the latest Flutter SDK
- Run `flutter doctor` to check for issues
- Run `flutter pub get` to ensure dependencies are installed

---

## Quick Commands Reference

```bash
# Check connected devices
flutter devices

# Run on connected device
flutter run

# Build APK for release
flutter build apk

# Build APK for debug (faster, larger file)
flutter build apk --debug

# Check Flutter setup
flutter doctor

# Get dependencies
flutter pub get
```


# TumorHeal Flutter Frontend (Scaffold)

This project scaffold includes real payment SDK integration points for Stripe, Apple Pay, Google Pay and crypto payment flows.
**You must supply your own merchant credentials and follow the native platform setup steps** below to enable Apple/Google Pay and Stripe.

## What’s included
- Authentication flow (token storage)
- Payment flows (Stripe native + Google/Apple pay via `pay` + `flutter_stripe`)
- Health plans listing/subscription
- Reports viewer (opens backend URL)
- Food scanner (camera upload)
- Analytics dashboard (charts)
- Provider-based state management

## Important: Real Payment Integration Steps (summary)
### 1) Stripe (required for card payments & setup on backend)
- Create a Stripe account and get your **Publishable Key** and **Secret Key**
- Backend must implement endpoints to create PaymentIntent (server-side) and return `client_secret`
  - POST `/api/v1/payments/create_intent` with `{amount, currency}` -> returns `{client_secret}`
- Fill keys in `lib/config/keys.dart`:
  - `STRIPE_PUBLISHABLE_KEY`
  - `STRIPE_MERCHANT_ID` (for Apple/Google Pay integration steps)

### 2) Apple Pay (iOS)
- Enable Apple Pay in your Apple Developer account and create a Merchant ID
- Add Merchant ID to Xcode project capabilities (Signing & Capabilities → Apple Pay)
- Add the merchant id in `lib/config/keys.dart` as `APPLE_MERCHANT_ID`
- Add required entitlements in `ios/Runner/Entitlements.plist` and `Info.plist` (see comments in this README)

### 3) Google Pay (Android)
- Create a Google Pay merchant id or use test configuration
- Add `GOOGLE_PAY_MERCHANT_ID` in `lib/config/keys.dart`
- Configure `AndroidManifest.xml` per `pay` package docs (wallet environment)

### 4) Crypto payments
- Use backend to generate crypto payment addresses; frontend shows QR & polls status
- Implement POST `/api/v1/payments/crypto` on backend which returns `{paymentAddress, paymentId}`

## Native iOS setup (brief)
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Add Apple Pay merchant in Signing & Capabilities.
3. In `Info.plist`, add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`.
4. Add `Podfile` platform to at least iOS 13.0.

## Native Android setup (brief)
1. In `android/app/src/main/AndroidManifest.xml` add camera and internet permissions.
2. Ensure `minSdkVersion` >= 21.
3. For Google Pay, follow `pay` package doc to add wallet configurations if needed.

## Where to put keys
Edit `lib/config/keys.dart` and fill in your values. Do NOT commit secret keys to public repos.

## How to run
1. Install Flutter SDK and set up platforms.
2. `flutter pub get`
3. For iOS: `cd ios && pod install`
4. Run `flutter run` on a device (Apple Pay requires a real iOS device; Google Pay recommended on device).

---
See `lib/` for code files and comments explaining how to wire backend and native credential values.

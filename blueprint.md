# UnityLink Application Blueprint

## 1. Overview

UnityLink is a modern, feature-rich chat application designed to connect users seamlessly. It leverages Firebase for its backend services, providing real-time communication, robust user authentication, and advanced AI-powered features. The application is built with Flutter, ensuring a beautiful, responsive, and cross-platform experience on both mobile and web.

## 2. Core Features & Design

### Authentication

*   **Email & Password:** Standard sign-up and sign-in.
*   **Google Sign-In:** One-tap authentication using Google accounts.
*   **Anonymous Sign-In:** Guest access for users to try the app.
*   **Persistent Login:** Users remain logged in across app restarts.

### Real-time Chat

*   **One-on-One & Group Chats:** Users can create and participate in private and group conversations.
*   **Real-time Messaging:** Messages are sent and received instantly, powered by Firestore.
*   **Video Calls:** Integrated Jitsi Meet SDK for high-quality video conferencing.
*   **Message Reactions & Deletion:** Interactive message options.

### User Profiles

*   **Customizable Profiles:** Users can set a display name and a profile picture.
*   **Profile Picture Management:** Upload images from the device gallery.

### AI-Powered Features (Gemini)

*   **Image Analysis:** Users can have their profile pictures analyzed by Google's Gemini model, which provides a creative and fun description of the image.

### Design & UI/UX

*   **Material 3 Design:** The app uses the latest Material Design guidelines for a modern and intuitive UI.
*   **Light & Dark Themes:** A theme provider allows users to switch between light and dark modes.
*   **Custom Fonts:** `google_fonts` is used for a unique and expressive typographical style.
*   **Responsive Layout:** The UI is designed to adapt gracefully to different screen sizes.

## 3. Current Implementation Plan

**Objective:** Implement and integrate a multimodal AI feature for analyzing user profile pictures.

**Status:** **Completed**

**Steps Taken:**

1.  **`StorageService` Creation:**
    *   Created `lib/services/storage_service.dart` to manage image uploads to Firebase Storage and retrieve their `gs://` URIs.

2.  **`GeminiService` Enhancement:**
    *   Updated `lib/services/gemini_service.dart` with an `analyzeImage` method that takes a prompt and a `gs://` image URI.
    *   This method uses the `gemini-1.5-flash` model to perform multimodal analysis.

3.  **`ProfileScreen` Integration:**
    *   Modified `lib/screens/profile_screen.dart` to integrate the new services.
    *   Added an "Analyze Profile Picture" button.
    *   Implemented the logic to upload the image, retrieve its URI, call the analysis service, and display the result in a dialog.

4.  **Dependency & Provider Setup:**
    *   Verified all necessary dependencies (`firebase_ai`, `firebase_storage`, `image_picker`) are in `pubspec.yaml`.
    *   Ran `flutter pub get` to ensure dependencies are fetched.
    *   Updated `lib/main.dart` to provide the `StorageService` and `GeminiService` to the application via `MultiProvider`.

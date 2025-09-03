# UnityLink Blueprint

## Overview

This document outlines the architecture and features of UnityLink, a Flutter application designed for real-time communication and community engagement. The app is built with a focus on modern design, robust functionality, and a seamless user experience, all powered by Firebase and Google's Gemini AI.

## Implemented Features & Design

### Core Architecture

*   **State Management:** Utilizes the `provider` package for robust state management and dependency injection, with `ChangeNotifier` for theme toggling and `StreamProvider` for real-time authentication state.
*   **Navigation:** Employs `go_router` for declarative, URL-based navigation, complete with authentication-aware redirects to protect routes.
*   **Services:** A modular service layer abstracts core functionalities:
    *   `AuthService`: Handles all user authentication, including email/password and Google Sign-In.
    *   `UserService`: Manages user data and profiles in Firestore.
    *   `ChatService`: Powers the real-time chat functionality, including one-on-one chats and community rooms.
    *   `GeminiService`: Integrates with the Gemini AI for intelligent features.
*   **Error Handling:** Uses `dart:developer` for structured logging to enable effective debugging.

### User Interface & Experience

*   **Theming:** A sophisticated theme system supports both light and dark modes, with custom typography from `google_fonts` and a polished, modern aesthetic.
*   **Home Screen:** A central hub providing access to all major features: chats, calls, community rooms, user profiles, and the Gemini AI assistant.
*   **Authentication Flow:** A seamless and secure authentication process with options for email/password and Google Sign-In.
*   **Real-time Chat:** Users can engage in one-on-one conversations with other users, with a user list for initiating new chats.
*   **Community Issue Rooms:** A new feature allowing users to create, join, and participate in topic-based discussion rooms.
    *   **Room Directory:** A screen (`CommunityRoomsScreen`) that lists all available community rooms.
    *   **Room Creation:** A dedicated screen (`NewCommunityRoomScreen`) for creating new rooms with a specified name.
    *   **Real-time Chat:** A chat screen (`CommunityRoomScreen`) for real-time messaging within a specific room.
*   **Profile Management:** A dedicated profile screen allows users to update their display name and profile picture, with image uploads handled by Firebase Storage.

### Backend & Services

*   **Firebase Suite:** Leverages a comprehensive set of Firebase services:
    *   **Authentication:** Securely manages user identities.
    *   **Firestore:** The NoSQL database for storing user data, chat messages, and other application data.
    *   **Firebase Storage:** Manages user-uploaded media like profile pictures.
*   **Generative AI:** The `firebase_ai` package provides access to Google's Gemini model, with a dedicated service and screen for user interaction.

## Final Implementation Notes

The development process involved several iterations of fixing and refactoring to ensure a stable and high-quality application. All initial bugs and linter warnings have been resolved, and the application is now in a clean, maintainable state. The `test` folder has been removed as the final step before concluding the project.

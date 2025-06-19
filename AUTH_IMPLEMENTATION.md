# Authentication Feature Implementation

## Overview
This Flutter project now includes a complete authentication system with sign-in and sign-up functionality following clean architecture principles with Bloc state management.

## Features Implemented

### 🔐 Authentication Pages
- **Sign In Page** (`/signin`) - Login with email/username and password
- **Sign Up Page** (`/signup`) - Registration with email verification flow
- **Email Verification Page** (`/email-verification`) - Post-signup verification guide

### 🏗️ Clean Architecture Structure

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_datasource.dart          # Remote & Local data sources
│   ├── models/
│   │   ├── user_model.dart               # User model with JSON serialization
│   │   └── user_model.g.dart             # Generated JSON code
│   └── repositories/
│       └── auth_repository_impl.dart     # Repository implementation
├── domain/
│   ├── entities/
│   │   └── user.dart                     # User entity
│   ├── repositories/
│   │   └── auth_repository.dart          # Repository interface
│   └── usecases/
│       ├── sign_in_usecase.dart         # Sign in use case
│       ├── sign_up_usecase.dart         # Sign up use case
│       ├── sign_out_usecase.dart        # Sign out use case
│       └── get_current_user_usecase.dart # Get current user use case
├── presentation/
│   ├── bloc/
│   │   ├── auth_bloc.dart               # Authentication Bloc
│   │   ├── auth_event.dart              # Authentication events
│   │   └── auth_state.dart              # Authentication states
│   ├── pages/
│   │   ├── sign_in_page.dart            # Sign in UI
│   │   ├── sign_up_page.dart            # Sign up UI
│   │   └── email_verification_page.dart  # Email verification UI
│   └── widgets/
│       ├── auth_form_field.dart         # Custom form field widget
│       ├── auth_button.dart             # Custom auth button widget
│       └── auth_social_button.dart      # Social login button widget
└── injection/
    └── auth_injection.dart              # Dependency injection setup
```

## API Integration

### Sign In Endpoint
- **URL**: `https://businessclassprofile.com/api/authentication_api/login`
- **Method**: POST
- **Payload**: 
  ```json
  {
    "emailOrUsername": "user@example.com",
    "password": "password"
  }
  ```
- **Response**:
  ```json
  {
    "status": "success",
    "message": "Login successful",
    "token": "jwt_token_here",
    "user": {
      "_id": "user_id",
      "email": "user@example.com",
      "displayName": "User Name",
      "username": "username",
      "country": "Country",
      "role": "user",
      "status": "active"
    }
  }
  ```

### Sign Up Endpoint
- **URL**: `https://businessclassprofile.com/api/authentication_api/signup`
- **Method**: POST
- **Payload**:
  ```json
  {
    "displayName": "User Name",
    "email": "user@example.com",
    "password": "password",
    "country": "Country"
  }
  ```
- **Response**:
  ```json
  {
    "status": "success",
    "message": "Check your email to verify your account"
  }
  ```

## State Management

### Authentication States
- `AuthInitial` - Initial state
- `AuthLoading` - Loading during authentication operations
- `AuthAuthenticated` - User successfully authenticated
- `AuthUnauthenticated` - User not authenticated
- `AuthError` - Authentication error occurred
- `SignUpSuccess` - Sign up successful, awaiting email verification

### Authentication Events
- `SignInRequested` - Trigger sign in
- `SignUpRequested` - Trigger sign up
- `SignOutRequested` - Trigger sign out
- `CheckAuthStatus` - Check current authentication status

## UI Components

### Custom Widgets
- **AuthFormField**: Styled text input field with validation
- **AuthButton**: Loading-capable authentication button
- **AuthSocialButton**: Social media login button (placeholder)

### Form Validation
- Email format validation
- Password strength requirements (minimum 8 characters)
- Confirm password matching
- Required field validation

## Navigation Flow

1. **App Launch**: Redirects to sign-in page
2. **Sign In Success**: Navigate to home page
3. **Sign Up Success**: Navigate to email verification page
4. **Email Verification**: Guide user to check email and return to sign in
5. **Sign Out**: Clear user data and return to sign in

## Local Storage

- **Authentication Token**: Stored securely in SharedPreferences
- **User Data**: Cached locally for offline access
- **Auto Sign Out**: Clears all local data on sign out

## Dependencies Used

- `flutter_bloc`: State management
- `get_it` + `injectable`: Dependency injection
- `go_router`: Navigation
- `dio`: HTTP client
- `shared_preferences`: Local storage
- `json_annotation`: JSON serialization
- `equatable`: Value equality
- `dartz`: Functional programming (Either type)

## Running the App

1. Ensure all dependencies are installed:
   ```bash
   flutter pub get
   ```

2. Generate code for JSON serialization and dependency injection:
   ```bash
   dart run build_runner build
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Testing

The app starts at the sign-in page. You can:
- Test sign up with valid email and password
- Receive email verification instructions
- Test sign in with existing credentials
- Use the sign out button on the home page

## Future Enhancements

- [ ] Biometric authentication
- [ ] Password reset functionality
- [ ] Social media login integration
- [ ] Remember me functionality
- [ ] Auto-login with stored tokens
- [ ] Token refresh mechanism
- [ ] Enhanced error handling
- [ ] Unit and integration tests

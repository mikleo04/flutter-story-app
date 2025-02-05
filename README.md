# Story Sharing App

A feature-rich Flutter application that enables users to share their stories with photos, locations, and descriptions. The app combines secure authentication, interactive maps, and smooth infinite scrolling for an engaging user experience.

## Features

### Authentication System
- Secure login and registration system
- Password masking for enhanced security
- Session management using preferences storage
- Automatic login for returning users
- Convenient logout functionality

### Story Features
- Browse stories from other users with infinite scroll pagination
- View detailed story information including:
  - User profile
  - Story photos
  - Story descriptions
  - Location on interactive map (when available)
- Create and share new stories
- Add photos with descriptions to your stories

### Location Features
- Interactive map integration in story details
- Location selection through map interface when adding stories
- Location input field for manual address entry
- Display address information when map markers are tapped
- Accurate location tracking and display

### Technical Highlights
- Implements declarative navigation throughout the app
- Code generation for all object classes
- Infinite scrolling pagination for story lists
- Secure data handling and storage
- Responsive design for various screen sizes
- Integration with REST API for story data
- Interactive map integration
- Clean and intuitive user interface

## Pages

### Authentication Pages
- **Login Page**: Secure user authentication
- **Register Page**: New user registration with validation

### Main Pages
- **Story List**: Displays paginated stories with infinite scroll
- **Story Detail**: Shows comprehensive story information with location map
- **Add Story**: Interface for creating stories with location selection

## Technologies Used

- Flutter
- Dart
- Google Maps Flutter integration
- Declarative Navigation
- Shared Preferences for session management
- REST API integration
- Image picking and handling
- Code generation tools
- Pagination implementation

## Installation

1. Clone this repository
```bash
git clone https://github.com/yourusername/story-app.git
```

2. Get dependencies
```bash
flutter pub get
```

3. Configure map API key
```
Add your Google Maps API key in AndroidManifest.xml and AppDelegate.swift
```

4. Run the app
```bash
flutter run
```

## Contributing

Contributions are welcome! Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

---
Built with Flutter ❤️

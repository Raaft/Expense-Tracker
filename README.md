# Expense Tracker Flutter App

A modern, responsive expense tracking application built with Flutter that helps users manage their personal finances with features like expense categorization, PDF export, and real-time currency conversion.

## 📱 Features

- **Expense Management**: Add, view, and categorize expenses
- **PDF Export**: Export expense reports as PDF documents
- **Responsive UI**: Works seamlessly on mobile, tablet, and desktop
- **Real-time Currency Conversion**: Support for multiple currencies
- **Receipt Upload**: Attach receipt images to expenses
- **Pagination**: Efficient loading of large expense lists
- **Modern UI**: Clean, intuitive interface with animations

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with a layered structure:

```
lib/
├── core/                    # Core functionality
│   ├── db/                 # Database configuration
│   ├── di/                 # Dependency injection
│   └── network/            # Network layer (Dio client)
├── features/               # Feature modules
│   └── expenses/           # Expense feature
│       ├── data/           # Data layer
│       │   ├── datasources/    # Local and remote data sources
│       │   ├── models/         # Data models
│       │   └── repositories/   # Repository implementations
│       ├── domain/         # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   └── usecases/       # Business logic
│       └── presentation/   # Presentation layer
│           ├── blocs/          # State management
│           ├── pages/          # UI screens
│           └── widgets/        # Reusable components
└── main.dart              # App entry point
```

### Architecture Benefits:
- **Separation of Concerns**: Each layer has a specific responsibility
- **Testability**: Easy to unit test business logic
- **Maintainability**: Clear structure makes code easy to understand
- **Scalability**: Easy to add new features without affecting existing code

## 🔄 State Management Approach

The app uses **BLoC (Business Logic Component)** pattern for state management:

### Why BLoC?
- **Predictable State Changes**: All state changes go through events
- **Testability**: Easy to test business logic in isolation
- **Reusability**: BLoCs can be reused across different widgets
- **Separation of Concerns**: UI is separated from business logic

### State Management Structure:
```dart
// Event → BLoC → State → UI
LoadFirstPage() → ListExpensesBloc → ListExpensesState → DashboardPage
```

### Key BLoCs:
- `ListExpensesBloc`: Manages expense list with pagination
- `AddExpenseBloc`: Handles expense creation and validation

## 🌐 API Integration

The app uses **Dio** for HTTP requests with a clean abstraction:

### Network Layer Features:
- **Base URL Configuration**: Centralized API endpoint management
- **Error Handling**: Comprehensive error handling with custom exceptions
- **Request/Response Interceptors**: Logging and authentication
- **Retry Logic**: Automatic retry for failed requests

### API Integration Strategy:
```dart
// Repository Pattern
abstract class ExpensesRepo {
  Future<List<Expense>> getExpenses({required int page, required int pageSize});
  Future<void> addExpense(Expense expense);
}

// Implementation
class ExpensesRepoImpl implements ExpensesRepo {
  final DioClient _dioClient;
  // Implementation details
}
```

## 📄 Pagination Strategy

The app implements **local pagination** with the following strategy:

### Pagination Implementation:
- **Page Size**: 10 items per page
- **Load More**: Automatic loading when user scrolls near bottom
- **State Management**: BLoC handles pagination state
- **Caching**: Local database caches loaded items

### Benefits:
- **Performance**: Only loads necessary data
- **User Experience**: Smooth scrolling without loading delays
- **Memory Efficiency**: Doesn't load all data at once
- **Offline Support**: Cached data available offline

## 🎨 UI/UX Design

### Design Principles:
- **Material Design**: Follows Google's Material Design guidelines
- **Responsive Design**: Adapts to different screen sizes
- **Accessibility**: Supports screen readers and accessibility features
- **Dark/Light Theme**: Support for both themes (planned)

### Key UI Components:
- **Dashboard**: Overview with balance card and recent expenses
- **Add Expense**: Form with category selection and receipt upload
- **Expense List**: Paginated list with smooth animations
- **PDF Export**: Professional expense reports

## 📱 Screenshots

### Dashboard Screen
![Dashboard](assets/screenshots/dashboard.png)
- **Balance Overview**: Total balance, income, and expenses
- **Recent Expenses**: Latest transactions with categories
- **PDF Export**: Tap expenses to generate PDF report
- **Responsive Design**: Adapts to tablet and desktop

### Add Expense Screen
![Add Expense](assets/screenshots/add_expense.png)
- **Category Selection**: Grid of expense categories
- **Amount Input**: Currency-aware amount field
- **Date Picker**: Easy date selection
- **Receipt Upload**: Camera integration for receipts

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK 3.32.0 or higher
- Dart SDK 3.3.3 or higher
- Android Studio / VS Code
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/expense-tracker.git
   cd expense-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android (API 21+)
- ✅ iOS (iOS 12.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Desktop (Windows, macOS, Linux)

## 🧪 Testing

### Test Coverage
The app includes comprehensive testing:

- **Unit Tests**: Business logic and validation
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/expense_validation_test.dart
```

### Test Categories:
1. **Expense Validation**: Tests for valid/invalid expense data
2. **Currency Calculation**: Tests for currency conversion logic
3. **Pagination Logic**: Tests for pagination behavior
4. **BLoC Testing**: Tests for state management

## 🚀 CI/CD Pipeline

The project uses **GitHub Actions** for continuous integration:

### CI/CD Features:
- **Automated Testing**: Runs tests on every push/PR
- **Code Analysis**: Flutter analyze for code quality
- **Multi-platform Builds**: Android, iOS, and Web builds
- **Coverage Reporting**: Codecov integration
- **Artifact Upload**: Build artifacts for deployment

### Workflow Stages:
1. **Test**: Run unit tests and code analysis
2. **Build Android**: Generate APK and App Bundle
3. **Build iOS**: Generate iOS build
4. **Build Web**: Generate web build
5. **Deploy**: Deploy to production (on main branch)

## 📦 Dependencies

### Core Dependencies:
- **flutter_bloc**: State management
- **dio**: HTTP client
- **sqflite**: Local database
- **pdf**: PDF generation
- **printing**: PDF printing
- **image_picker**: Image selection
- **flutter_screenutil**: Responsive design

### Development Dependencies:
- **mocktail**: Mocking for tests
- **bloc_test**: BLoC testing utilities
- **flutter_test**: Flutter testing framework

## 🔄 Trade-offs and Assumptions

### Design Decisions:

1. **Local Database First**: 
   - **Trade-off**: Requires sync mechanism for multi-device
   - **Benefit**: Works offline, faster performance

2. **BLoC Pattern**:
   - **Trade-off**: More boilerplate code
   - **Benefit**: Better testability and maintainability

3. **PDF Export**:
   - **Trade-off**: Larger app size due to PDF library
   - **Benefit**: Professional reporting feature

4. **Responsive Design**:
   - **Trade-off**: More complex UI code
   - **Benefit**: Better user experience across devices

### Assumptions:
- Users have stable internet for initial data sync
- Receipt images are stored locally (not cloud)
- Currency conversion rates are fetched from API
- PDF export is client-side only

## 🐛 Known Issues and Limitations

### Current Limitations:
- **Offline Mode**: Limited functionality when offline
- **Multi-device Sync**: Not implemented yet
- **Cloud Storage**: Receipts not backed up to cloud
- **Advanced Analytics**: Basic reporting only

### Planned Features:
- [ ] Cloud sync for multi-device support
- [ ] Advanced analytics and charts
- [ ] Budget planning and alerts
- [ ] Export to CSV format
- [ ] Dark theme support
- [ ] Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Shihab Rahman**
- GitHub: [@shihabrahman](https://github.com/shihabrahman)
- LinkedIn: [Shihab Rahman](https://linkedin.com/in/shihabrahman)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library contributors
- Material Design team for design guidelines
- All open-source contributors whose packages made this possible



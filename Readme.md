# Rick and Morty Character Explorer

## Overview
This iOS application fetches and displays characters from the Rick and Morty API, providing a paginated list view and detailed character information.

## Build Requirements
- Xcode 16.0+
- Swift 5.9+
- iOS 16.0+

## Setup and Installation
1. Clone the repository
2. Open the project in Xcode
3. Resolve Swift Package Manager dependencies
   - Xcode will automatically download and integrate the following packages:
     - Kingfisher (image loading and caching)
     - SnapKit (auto layout)
     - CombineDataSources (reactive data sources)
4. Build and run the project in Xcode

## Architecture and Design Decisions
- Implemented using a hybrid approach with UIKit and SwiftUI
- MVVM (Model-View-ViewModel) architectural pattern
- Utilized Swift's modern concurrency features (async/await)
- Leverage Combine for reactive programming
- Dependency injection for improved testability

## Key Technologies
- Kingfisher for efficient image loading and caching
- SnapKit for declarative, type-safe Auto Layout
- CombineDataSources for reactive table and collection view data sources
- Combine framework for reactive programming

## API Integration
- Used Rick and Morty public API (https://rickandmortyapi.com/)
- Implemented pagination

## Features
### Character List Screen
- Displays characters, includes character:
  - Name
  - Image
  - Species
- Filtering functionality by character status (alive, dead, unknown)

### Character Details Screen
Displays comprehensive character information:
- Name
- Image
- Species
- Status
- Gender
- Location

## Assumptions Made
- Assumed standard internet connectivity
- Implemented basic error handling for network requests
- Assumed support for iOS 16.0+ devices

## Challenges and Solutions

### UIKit and SwiftUIs
**Challenge**: Combining UIKit and SwiftUI
**Solution**: 
- Used UIHostingController & UIHostingConfiguration to embed SwiftUI views seamlessly

### API Pagination
**Challenge**: Implementing efficient pagination with smooth user experience
**Solution**: 
- Developed a request mechanism that:
  - Fetches characters incrementally (20 per page)
  - Prevents redundant network calls
  - Handles edge cases like last page reaching

### Image Handling
**Challenge**: Managing image downloads and caching
**Solution**: 
- Leveraged Kingfisher for robust image loading

### Layout Management
**Challenge**: Creating flexible and responsive layouts
**Solution**:
- Used SnapKit for declarative, constraint-based layouts

### Status Filtering
**Challenge**: Creating a flexible filtering mechanism
**Solution**:
- Used `Enum` for status types
- Implemented reactive filtering with Combine

## Testing
- Unit tests covering:
  - View model logic
- Mock data used for consistent testing
- Used XCTest framework for test implementation

## Future Improvements
- Implement more advanced filtering options
- Enhance error handling
- Implement coordinator design pattern

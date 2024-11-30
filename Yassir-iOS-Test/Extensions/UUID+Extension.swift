import Foundation

/// Provides a placeholder UUID value for use in unit tests.
extension UUID {
    private static let placeholder = UUID()

    /// Returns a placeholder UUID value for testing scenarios or a new UUID value for production code.
    static func generate() -> UUID {
        guard NSClassFromString("XCTest") != nil else {
            return UUID()
        }

        return placeholder
    }
}

import Foundation

enum ViewState: Equatable {
    case loading(isUserInteractionEnabled: Bool)
    case error(message: String)
    case idle
}

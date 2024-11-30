import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Int)
    case encodingFailed(Error)
    case decodingFailed(Error)
    case multipleBodiesNotAllowed
    case unknown(Error)
}

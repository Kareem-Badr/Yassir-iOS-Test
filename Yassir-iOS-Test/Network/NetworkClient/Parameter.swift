import Foundation

enum Parameter {
    case path(String, String)
    case query(String, String)
    case body(Encodable)
}

extension [Parameter] {
    func body() throws -> Encodable? {
        let bodies = self.compactMap { param -> Encodable? in
            if case .body(let body) = param { return body }
            return nil
        }
        
        guard bodies.count <= 1 else {
            throw NetworkError.multipleBodiesNotAllowed
        }
        
        return bodies.first
    }
}

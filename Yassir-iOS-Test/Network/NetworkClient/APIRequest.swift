import Foundation

protocol APIRequest<Response> {
    associatedtype Response: Decodable
    
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [Parameter] { get }
}

extension APIRequest {
    private func replacePathParameters(in path: String, with parameters: [Parameter]) -> String {
        parameters.reduce(path) { updatedPath, parameter in
            guard case .path(let key, let value) = parameter else { return updatedPath }
            return updatedPath.replacingOccurrences(of: "{\(key)}", with: value)
        }
    }
    
    private func encode(_ encodable: Encodable) throws -> Data {
        do {
            return try JSONEncoder().encode(encodable)
        } catch {
            throw NetworkError.encodingFailed(error)
        }
    }

    private func constructURL(endpoint: String) throws -> URL {
        guard
            let baseURL,
            var urlComponents = URLComponents(
                url: baseURL.appendingPathComponent(endpoint),
                resolvingAgainstBaseURL: false
            )
        else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = parameters.compactMap { param in
            guard case let .query(key, value) = param else { return nil }
            return URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }

    private func createRequest(for url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if method != .get, let body = try parameters.body() {
            request.httpBody = try encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }

    
    func asURLRequest() throws -> URLRequest {
        let endpoint = replacePathParameters(in: path, with: parameters)
        let url = try constructURL(endpoint: endpoint)
        return try createRequest(for: url)
    }
}

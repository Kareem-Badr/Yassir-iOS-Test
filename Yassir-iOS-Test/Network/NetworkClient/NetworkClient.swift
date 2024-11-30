import Foundation

protocol NetworkClient: Sendable {
    func request<T: APIRequest>(_ apiRequest: T) async throws -> T.Response
}

final class DefaultNetworkClient: NetworkClient, Sendable {
    func request<T: APIRequest>(_ apiRequest: T) async throws -> T.Response {
        let request = try apiRequest.asURLRequest()
        let (data, response) = try await performRequest(request)
        return try decodeResponse(data, response: response)
    }

    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    private func decodeResponse<T: Decodable>(_ data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "Invalid response", code: 0))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(httpResponse.statusCode)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}

import Foundation

struct ListCharactersRequest: APIRequest {
    typealias Response = PaginatedResponse<Character>
    
    var baseURL: URL? { Configuration.baseURL }
    
    var path: String { "/character" }
    
    var method: HTTPMethod { .get }
    
    var headers: [String: String]? { nil }
    
    let parameters: [Parameter]
    
    init(page: Int, status: CharacterStatus?) {
        parameters = [
            .query("page", "\(page)"),
            status.map { .query("status", $0.rawValue) }
        ].compactMap { $0 }
    }
}

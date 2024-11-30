import Foundation

struct PageInfo: Decodable {
    let nextPage: String?
    
    private enum CodingKeys: String, CodingKey {
        case nextPage = "next"
    }
}

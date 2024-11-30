struct PaginatedResponse<T: Decodable>: Decodable {
    let pageInfo: PageInfo
    let data: [T]
    
    private enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case data = "results"
    }
}

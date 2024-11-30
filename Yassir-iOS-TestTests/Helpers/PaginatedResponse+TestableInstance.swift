@testable import Yassir_iOS_Test

extension PaginatedResponse {
    static func testableInstance(
        pageInfo: PageInfo = .testableInstance(),
        data: [T]
    ) -> PaginatedResponse {
        PaginatedResponse(
            pageInfo: pageInfo,
            data: data
        )
    }
}

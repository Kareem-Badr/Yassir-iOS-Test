@testable import Yassir_iOS_Test

extension PageInfo {
    static func testableInstance(nextPage: String? = nil) -> PageInfo {
        PageInfo(nextPage: nextPage)
    }
}

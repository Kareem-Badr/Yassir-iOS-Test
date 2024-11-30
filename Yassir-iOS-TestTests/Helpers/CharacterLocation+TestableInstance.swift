@testable import Yassir_iOS_Test

extension CharacterLocation {
    static func testableInstance(name: String = "Earth") -> CharacterLocation {
        CharacterLocation(name: name)
    }
}

@testable import Yassir_iOS_Test
import Foundation

extension Character {
    static func testableInstance(
        id: Int = 1,
        name: String = "Rick Sanchez",
        species: String = "Human",
        status: CharacterStatus = .alive,
        gender: String = "Male",
        imageURL: URL? = URL(string: ""),
        location: CharacterLocation = .testableInstance()
    ) -> Character {
        Character(
            id: id,
            name: name,
            species: species,
            status: status,
            gender: gender,
            imageURL: imageURL,
            location: location
        )
    }
}

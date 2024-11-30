import Foundation
import UIKit

struct Character: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let species: String
    let status: CharacterStatus
    let gender: String
    let imageURL: URL?
    let location: CharacterLocation
    
    private enum CodingKeys: String, CodingKey {
        case id, name, species
        case status, gender
        case imageURL = "image"
        case location
    }
}

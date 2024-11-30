enum CharacterStatus: String, CaseIterable, Decodable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
}

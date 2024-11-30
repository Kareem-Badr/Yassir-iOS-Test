import Foundation

struct CharacterTableViewCellViewModel {
    let id: String
    let name: String
    let species: String
    let imageURL: URL?
    let characterStatusViewModel: CharacterStatusViewModel
    let shouldHideBorder: Bool
    let onTap: () -> Void
    
    init(
        name: String,
        species: String,
        imageURL: URL?,
        characterStatusViewModel: CharacterStatusViewModel,
        shouldHideBorder: Bool,
        onTap: @escaping () -> Void
    ) {
        self.id = UUID.generate().uuidString
        self.name = name
        self.species = species
        self.imageURL = imageURL
        self.characterStatusViewModel = characterStatusViewModel
        self.shouldHideBorder = shouldHideBorder
        self.onTap = onTap
    }
}

extension CharacterTableViewCellViewModel: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.species == rhs.species &&
        lhs.imageURL == rhs.imageURL &&
        lhs.characterStatusViewModel == rhs.characterStatusViewModel &&
        lhs.shouldHideBorder == rhs.shouldHideBorder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(species)
        hasher.combine(imageURL)
        hasher.combine(characterStatusViewModel)
        hasher.combine(shouldHideBorder)
    }
}

extension CharacterTableViewCellViewModel {
    init(
        character: Character,
        onTap: @escaping () -> Void
    ) {
        self.init(
            name: character.name,
            species: character.species,
            imageURL: character.imageURL,
            characterStatusViewModel: CharacterStatusViewModel(status: character.status),
            shouldHideBorder: character.status != .unknown,
            onTap: onTap
        )
    }
}

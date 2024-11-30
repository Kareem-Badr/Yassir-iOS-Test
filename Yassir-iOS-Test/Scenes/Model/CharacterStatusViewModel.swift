import SwiftUI

struct CharacterStatusViewModel: Hashable, Identifiable {
    let id: String
    let status: CharacterStatus
    let title: String
    
    var color: Color {
        switch status {
        case .alive:
            Color.characterStatusAlive
            
        case .dead:
            Color.characterStatusDead
            
        case .unknown:
            Color.clear
        }
    }
    
    init(status: CharacterStatus) {
        self.id = UUID.generate().uuidString
        self.status = status
        self.title = switch status {
        case .alive:
            "Alive"
            
        case .dead:
            "Dead"
            
        case .unknown:
            "Unknown"
        }
    }
}

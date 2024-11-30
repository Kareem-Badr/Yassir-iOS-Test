import Foundation
import Combine
import CombineDataSources

protocol CharacterRepository {
    func getCharacters(page: Int, status: CharacterStatus?) async throws -> PaginatedResponse<Character>
}

final class DefaultCharacterRepository: CharacterRepository {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getCharacters(
        page: Int,
        status: CharacterStatus?
    ) async throws -> PaginatedResponse<Character> {
        let request = ListCharactersRequest(page: page, status: status)
        return try await networkClient.request(request)
    }
}

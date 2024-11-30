import XCTest
@preconcurrency import Combine
@testable import Yassir_iOS_Test

final class Yassir_iOS_TestTests: XCTestCase {
    override func setUp() {
        super.setUp()
        mockCharacterRepository = MockCharacterRepository()
        viewModel = CharactersListViewModel(characterRepository: mockCharacterRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func test_viewDidLoadTrigger_getsCharactersWithInitialState() {
        // Given
        let recorder = mockCharacterRepository.getCharactersTrigger.recorder(count: 1)
        
        // When
        viewModel.input.viewDidLoadTrigger.send()
        let records = recorder.record()
        
        // Then
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.0, 1)
        XCTAssertEqual(records.first?.1, nil)
    }
    
    func test_loadData_updatesViewState_toLoading() {
        // Given
        let recorder = viewModel.output.$viewState.recorder(count: 2)
        
        // When
        viewModel.input.viewDidLoadTrigger.send()
        let records = recorder.record()
        
        // Then
        XCTAssertEqual(
            records,
            [
                .idle, // Initial value
                .loading(isUserInteractionEnabled: true)
            ]
        )
    }
    
    func test_loadData_updatesDataSource_whenGetCharactersSucceeds() {
        // Given
        let recorder = viewModel.output.$dataSource.recorder(count: 2)
        let characters: [Character] = [
            .testableInstance(),
            .testableInstance(),
            .testableInstance()
        ]
        
        let expectedViewModels = makeViewModels(from: characters)
        
        mockCharacterRepository.getCharactersResult = .success(.testableInstance(data: characters))
        
        // When
        viewModel.input.viewDidLoadTrigger.send()
        let records = recorder.record()
        
        // Then
        XCTAssertEqual(
            records,
            [
                [],
                expectedViewModels
            ]
        )
    }
    
    func test_loadData_updatesViewState_toIdle_whenGetCharactersSucceeds() {
        // Given
        let recorder = viewModel.output.$viewState.recorder(count: 3)
        let characters: [Character] = [
            .testableInstance(),
            .testableInstance(),
            .testableInstance()
        ]
        
        mockCharacterRepository.getCharactersResult = .success(.testableInstance(data: characters))
        
        // When
        viewModel.input.viewDidLoadTrigger.send()
        let records = recorder.record()
        
        // Then
        XCTAssertEqual(
            records,
            [
                .idle,
                .loading(isUserInteractionEnabled: true),
                .idle
            ]
        )
    }
    
    private func makeViewModels(from characters: [Character]) -> [CharacterTableViewCellViewModel] {
        characters.map { character in
            CharacterTableViewCellViewModel(
                character: character,
                onTap: { }
            )
        }
    }
    
    private var mockCharacterRepository: MockCharacterRepository!
    private var viewModel: CharactersListViewModel!
}


final class MockCharacterRepository: CharacterRepository {
    let getCharactersTrigger = PassthroughSubject<(Int, CharacterStatus?), Never>()
    var getCharactersResult: Result<PaginatedResponse<Character>, Error> = .failure(MockError.unknown)
    func getCharacters(
        page: Int,
        status: CharacterStatus?
    ) async throws -> PaginatedResponse<Character> {
        getCharactersTrigger.send((page, status))
        return try getCharactersResult.get()
    }
}

enum MockError: Error {
    case unknown
}

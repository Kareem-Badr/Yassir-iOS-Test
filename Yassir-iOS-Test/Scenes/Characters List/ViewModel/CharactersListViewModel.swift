import Foundation
import Combine

final class CharactersListViewModel {
    enum Route {
        case characterDetails(viewModel: CharacterDetailViewModel)
    }
    
    final class Input {
        let viewDidLoadTrigger: UIEvent<Void> = PassthroughSubject<Void, Never>()
        let paginateTrigger: UIEvent<Void> = PassthroughSubject<Void, Never>()
        let filterTrigger = CurrentValueSubject<CharacterStatus?, Never>(nil)
    }
    
    final class Output {
        @Published fileprivate(set) var viewState: ViewState = .idle
        @Published fileprivate(set) var dataSource: [CharacterTableViewCellViewModel] = []
        @Published fileprivate(set) var characterStatuses = CharacterStatus.allCases.map(CharacterStatusViewModel.init)
        @Published fileprivate(set) var route: Route?
    }
    
    // MARK: DI
    private let characterRepository: CharacterRepository
    
    // MARK: Input / Output
    let input: Input
    let output: Output

    // MARK: Properties
    private var currentPage = 1
    private var isLastPage = false
    private var loadDataTask: Task<Void, Never>?
    private var paginationTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(characterRepository: CharacterRepository) {
        input = .init()
        
        output = .init()
        
        self.characterRepository = characterRepository
        
        observeViewDidLoadTrigger()
        observePaginateTrigger()
        observeFilterTrigger()
    }
}

// MARK: Observers
extension CharactersListViewModel {
    private func observeViewDidLoadTrigger() {
        input
            .viewDidLoadTrigger
            .sink { [weak self] in
                guard let self else { return }
                loadData(status: input.filterTrigger.value)
            }
            .store(in: &cancellables)
    }
    
    private func observePaginateTrigger() {
        input
            .paginateTrigger
            .sink { [weak self] in
                guard let self else { return }
                
                if !isLastPage {
                    loadNextPage(status: input.filterTrigger.value)
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeFilterTrigger() {
        input
            .filterTrigger
            .dropFirst()
            .sink { [weak self] status in
                guard let self else { return }
                loadData(status: status)
            }
            .store(in: &cancellables)
    }
}

// MARK: Network
extension CharactersListViewModel {
    private func loadData(status: CharacterStatus? = nil) {
        currentPage = 1
        loadDataTask?.cancel()
        paginationTask?.cancel()
        loadDataTask = Task { @MainActor in
            do {
                defer {
                    output.viewState = .idle
                }
                
                output.viewState = .loading(isUserInteractionEnabled: true)
                
                let response = try await characterRepository.getCharacters(
                    page: currentPage,
                    status: status
                )
                
                guard !Task.isCancelled else { return }
                
                isLastPage = response.pageInfo.nextPage == nil
                output.dataSource = makeViewModels(from: response.data)
            } catch {
                output.viewState = .error(message: error.localizedDescription)
            }
        }
    }
    
    private func loadNextPage(status: CharacterStatus? = nil) {
        loadDataTask?.cancel()
        paginationTask?.cancel()
        currentPage += 1
        
        paginationTask = Task { @MainActor in
            do {
                defer {
                    output.viewState = .idle
                }
                
                output.viewState = .loading(isUserInteractionEnabled: true)
                
                let response = try await characterRepository.getCharacters(page: currentPage, status: status)
                
                guard !Task.isCancelled else { return }
                
                isLastPage = response.pageInfo.nextPage == nil
                output.dataSource = output.dataSource + makeViewModels(from: response.data)
            } catch {
                currentPage -= 1
                output.viewState = .error(message: error.localizedDescription)
            }
        }
    }
    
    private func makeViewModels(from characters: [Character]) -> [CharacterTableViewCellViewModel] {
        characters.map { character in
            CharacterTableViewCellViewModel(
                character: character,
                onTap: { [weak self] in
                    guard let self else { return }
                    navigateToCharacterDetails(character: character)
                }
            )
        }
    }
}

// MARK: Functions
extension CharactersListViewModel {
    private func navigateToCharacterDetails(character: Character) {
        let viewModel = CharacterDetailViewModel(from: character)
        output.route = .characterDetails(viewModel: viewModel)
    }
}

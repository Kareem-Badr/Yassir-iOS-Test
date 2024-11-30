import UIKit
import SnapKit
import Combine
import CombineDataSources
import SwiftUI

final class CharactersListViewController: ViewController {
    private let viewModel: CharactersListViewModel
    private var selectedStatus: CharacterStatus?
    
    private lazy var tableViewDataSource: TableViewItemsController<[[CharacterTableViewCellViewModel]]> = {
        return TableViewItemsController { [weak self] _, tableView, indexPath, item in
            guard let self else { return .init() }
            return createCell(item: item, at: indexPath, from: tableView)
        }
    }()
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.backgroundColor = .white
        
        configureView()
        configureConstraints()
    }
    
    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Characters"
        
        addChild(filterViewController)
        filterViewController.didMove(toParent: self)
        
        view.addSubview(filterViewController.view)
        view.addSubview(tableView)
        
        tableView.register(cell: UITableViewCell.self)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        
        tableViewDataSource.animated = false
    }
    
    private func configureConstraints() {
        filterViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterViewController.view.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel
            .input
            .viewDidLoadTrigger
            .send()
        
        viewModel
            .output
            .$dataSource
            .subscribe(tableView.rowsSubscriber(tableViewDataSource))
        
        viewModel
            .output
            .$route
            .compactMap { $0 }
            .sink { [weak self] route in
                guard let self else { return }
                self.route(with: route)
            }
            .store(in: &cancellables)
        
    }
    
    private func route(with route: CharactersListViewModel.Route) {
        switch route {
        case .characterDetails(let viewModel):
            let detailViewController = UIHostingController(rootView: CharacterDetailView(viewModel: viewModel))
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    private func createCell(
        item: CharacterTableViewCellViewModel,
        at indexPath: IndexPath,
        from tableView: UITableView
    ) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath)
        cell.selectionStyle = .none
        cell.contentConfiguration = UIHostingConfiguration {
            CharacterTableViewCell(viewModel: item)
        }
        .margins([.horizontal, .top], 0)
        .margins(.bottom, 16)
        
        return cell
    }
    
    // MARK: Subviews
    private let tableView = UITableView()
    
    private lazy var filterViewController = UIHostingController(
        rootView: FilterView(viewModel: viewModel)
    )
}

extension CharactersListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            viewModel.input.paginateTrigger.send()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

extension CharactersListViewController {
    static func create() -> CharactersListViewController {
        let networkClient = DefaultNetworkClient()
        let characterRepository = DefaultCharacterRepository(networkClient: networkClient)
        let viewModel = CharactersListViewModel(characterRepository: characterRepository)
        return .init(viewModel: viewModel)
    }
}

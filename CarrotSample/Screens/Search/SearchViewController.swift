//
//  SearchViewController.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit
import Alamofire

protocol SearchViewInput {
    func setupInitialState()
    func tableViewNeedUpdate()
    func scrollTableViewToTop()
}

protocol SearchViewOutput {
    func viewIsReady()
    func searchBooksWith(keyword: String,
                         isScrolled: Bool)
    func numberOfBooks() -> Int
    func configureTableCell(cell: BookTableCell,
                            index: Int)
    func isbn(index: Int) -> String
}

class SearchScreenConfigurator {
    
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController,
                                                       interactorDependency: SearchInteractor.Dependency) {
        if let viewController = viewInput as? SearchViewController {
            configure(viewController: viewController,
                      dependency: interactorDependency)
        }
    }
    
    private func configure(viewController: SearchViewController,
                           dependency: SearchInteractor.Dependency) {
        let presenter = SearchPresenter()
        presenter.view = viewController
        let interactor = SearchInteractor()
        interactor.dependency = dependency
        interactor.output = presenter
        presenter.interactor = interactor
        viewController.output = presenter
    }
}

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!
    
    var tv: UITableView!
    var searchBar: UISearchBar!
    
    var lastContentOffset: CGFloat = 0.0
    var isScrollToLoading: Bool = false
    var keyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}

extension SearchViewController: SearchViewInput {
    
    func setupInitialState() {
        
        view.backgroundColor = .orange
        
        searchBar = {
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            return searchBar
        }()
        searchBar.delegate = self
        tv = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        tv.dataSource = self
        tv.delegate = self
        tv.register(BookTableCell.self, forCellReuseIdentifier: BookTableCell.reuseIdentifier)
        
        view.addSubview(searchBar)
        view.addSubview(tv)
        
        let constraints = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            tv.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func tableViewNeedUpdate() {
        tv.reloadData()
        isScrollToLoading = false
        view.hideSpinner()
    }
    
    func scrollTableViewToTop() {
        tv.scrollToRow(at: IndexPath(row: 0, section: 0),
                       at: .top,
                       animated: false)
        lastContentOffset = 0.0
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfBooks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableCell.reuseIdentifier) as? BookTableCell else {
            fatalError()
        }
        output.configureTableCell(cell: cell,
                                  index: indexPath.row)
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let configurator = DetailScreenConfigurator()
        let interactorDependency = DetailInteractor.Dependency(
            bookService: BookService(session: Session.default),
            memoryCacheService: MemoryCacheService(imageCache: NSCache<NSString, UIImage>()),
            diskCacheService: DiskCacheService(fileManager: FileManager.default))
        configurator.configureModuleForViewInput(
            viewInput: vc,
            interactorDependency: interactorDependency,
            bookIsbn: output.isbn(index: indexPath.row))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableCell.reuseIdentifier) as? BookTableCell else {
            fatalError()
        }
        return cell.cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        
        let offset = scrollView.contentOffset
        
        let contentSizeHeight = scrollView.contentSize.height
        let edgeOfScrollToLoadMore = scrollView.frame.size.height + offset.y + 200
        
        if (contentSizeHeight != 0) && (contentSizeHeight < edgeOfScrollToLoadMore) {
            if self.lastContentOffset > offset.y {
                // ...Scrolled up
            } else {
                self.lastContentOffset = offset.y
                if self.isScrollToLoading || self.keyword == nil {
                    return
                }
                self.isScrollToLoading = true
                self.output.searchBooksWith(keyword: self.keyword!,
                                            isScrolled: true)
                self.view.hideSpinner()
                self.view.showSpinner()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            self.keyword = keyword
            output.searchBooksWith(keyword: keyword,
                                   isScrolled: false)
            searchBar.resignFirstResponder()
            
        }
    }
}

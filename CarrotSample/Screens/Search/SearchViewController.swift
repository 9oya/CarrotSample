//
//  SearchViewController.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit

protocol SearchViewInput {
    func setupInitialState()
    func tableViewNeedUpdate()
    func scrollTableViewToTop()
}

protocol SearchViewOutput {
    func viewIsReady()
    func searchBooksWith(keyword: String, isScrolled: Bool)
    func numberOfBooks() -> Int
}

class SearchScreenConfigurator {
    
    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {
        if let viewController = viewInput as? SearchViewController {
            configure(viewController: viewController)
        }
    }
    
    private func configure(viewController: SearchViewController) {
        let presenter = SearchPresenter()
        presenter.view = viewController
        let interactor = SearchInteractor()
        interactor.output = presenter
        presenter.interactor = interactor
        viewController.output = presenter
    }
}

class SearchViewController: UIViewController {
    
    var output: SearchViewOutput!
    let configurator = SearchScreenConfigurator()
    
    var tv: UITableView!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureModuleForViewInput(viewInput: self)
        output.viewIsReady()
    }
}

extension SearchViewController: SearchViewInput {
    
    func setupInitialState() {
        
        searchBar = {
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            return searchBar
        }()
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
        
    }
    
    func tableViewNeedUpdate() {
        tv.reloadData()
    }
    
    func scrollTableViewToTop() {
        tv.scrollToRow(at: IndexPath(row: 0, section: 0),
                       at: .top,
                       animated: false)
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
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Route to DetailScreen...
        print(indexPath)
    }
}

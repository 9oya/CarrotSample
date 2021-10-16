//
//  DetailViewController.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit

protocol DetailViewInput {
    var isbn: String { get }
    func setupInitialState()
    func layoutViews()
    func scrollTableViewToTop()
}

protocol DetailViewOutput {
    func viewIsReady()
    func loadBookInfo(isbn: String)
    func numberOfBookInfos() -> Int
    func configureTableCell(cell: BookInfoTableCell,
                            index: Int)
    func configureTableCell(cell: BookInfoImgTableCell,
                            index: Int)
}

class DetailScreenConfigurator {
    
    func configureModuleForViewInput<UIViewController>(
        viewInput: UIViewController,
        interactorDependency: DetailInteractor.Dependency,
        bookIsbn: String
    ) {
        if let viewController = viewInput as? DetailViewController {
            configure(viewController: viewController,
                      dependency: interactorDependency,
                      bookIsbn: bookIsbn)
        }
    }
    
    private func configure(
        viewController: DetailViewController,
        dependency: DetailInteractor.Dependency,
        bookIsbn: String
    ) {
        let presenter = DetailPresenter()
        presenter.view = viewController
        let interactor = DetailInteractor()
        interactor.dependency = dependency
        interactor.output = presenter
        presenter.interactor = interactor
        viewController.output = presenter
        viewController.isbn = bookIsbn
    }
}

class DetailViewController: UIViewController, DetailViewInput {
    
    var output: DetailViewOutput!
    var tv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        output.loadBookInfo(isbn: isbn)
    }
    
    // MARK: DetailViewInput
    
    var isbn: String = ""
    
    func setupInitialState() {
        view.backgroundColor = .orange
        
        tv = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        tv.dataSource = self
        tv.delegate = self
        tv.register(BookInfoTableCell.self, forCellReuseIdentifier: BookInfoTableCell.reuseIdentifier)
        tv.register(BookInfoImgTableCell.self, forCellReuseIdentifier: BookInfoImgTableCell.reuseIdentifier)
        
        view.addSubview(tv)
        
        let constraints = [
            tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func layoutViews() {
        tv.reloadData()
    }
    
    func scrollTableViewToTop() {
        tv.scrollToRow(at: IndexPath(row: 0, section: 0),
                       at: .top,
                       animated: false)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfBookInfos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: BookInfoImgTableCell.reuseIdentifier) as? BookInfoImgTableCell {
            output.configureTableCell(cell: cell,
                                      index: indexPath.row)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: BookInfoTableCell.reuseIdentifier) as? BookInfoTableCell {
            output.configureTableCell(cell: cell,
                                      index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if indexPath.row == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: BookInfoImgTableCell.reuseIdentifier) as? BookInfoImgTableCell {
            height = cell.cellHeight
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: BookInfoTableCell.reuseIdentifier) as? BookInfoTableCell {
            height = cell.cellHeight
        }
        return height
    }
}

//
//  ViewController.swift
//  News
//
//  Created by Барбашина Яна on 05.02.2023.
//

import UIKit

class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView = UITableView(frame: .zero, style: .plain)
    var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
    }
    
    func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func configureTableView() {
        setRefreshButton()
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
        fetchNews()
    }
    
    private func setRefreshButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchNews))
    }
    
    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func refresh() {
        fetchNews()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc
    private func fetchNews() {
        ApiService.shared.getTopStories { [weak self] result in
            switch result {
                case .success(let articles):
                    self?.newsViewModels = articles.compactMap{
                        NewsViewModel(
                            title: $0.title,
                            description: $0.description ?? "No description",
                            imageURL: URL(string: $0.urlToImage ?? ""),
                            url: $0.url ?? "",
                            publishedAt: $0.publishedAt,
                            author: $0.author,
                            viewsCount: 0
                        )
                    }
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "No internet connection", message: "Please check your connection and try again", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            
        } else {
            return newsViewModels.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            
        } else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier:
                                                                NewsCell.reuseIdentifier, for: indexPath) as? NewsCell { newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.incrementView(viewModel: newsViewModels[indexPath.row])
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}


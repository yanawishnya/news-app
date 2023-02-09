//
//  NewsViewController.swift
//  News
//
//  Created by Барбашина Яна on 05.02.2023.
//

import UIKit
import WebKit

final class NewsViewController: UIViewController, WKUIDelegate {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let newsPublishedAtLabel = UILabel()
    private let authorLabel = UILabel()
    private let urlButton = UIButton()
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        setImageView()
        setTitleLabel()
        setDescriptionLabel()
        setupUrlButton()
        setupPublishedAtLabel()
        setupAuthorLabel()
    }
    
    private func setupNavbar() {
        navigationItem.title = "News"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setImageView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.pin(to: view, [.left: 0, .right: 0])
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.pinHeight(to: imageView.widthAnchor, 1)
    }
    
    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        
        view.addSubview(titleLabel)
        
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        titleLabel.pin(to: view, [.left: 16, .right: 16])
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        
        view.addSubview(descriptionLabel)
        descriptionLabel.pin(to: view, [.left: 16, .right: 16])
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
    }
    
    private func setupUrlButton() {
        urlButton.setTitleColor(.systemBlue, for: .normal)
        urlButton.titleLabel?.font = .systemFont(ofSize: 14)
        urlButton.addTarget(self, action:
                                #selector(urlButtonPressed), for: .touchUpInside)
        
        view.addSubview(urlButton)
        urlButton.pin(to: view, [.left: 16, .right: 16])
        urlButton.pinTop(to: descriptionLabel.bottomAnchor, 10)
    }
    
    private func setupPublishedAtLabel() {
        newsPublishedAtLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsPublishedAtLabel.textColor = .secondaryLabel
        
        view.addSubview(newsPublishedAtLabel)
        newsPublishedAtLabel.pin(to: view, [.left: 16, .right: 16])
        newsPublishedAtLabel.pinTop(to: urlButton.bottomAnchor, 8)
    }
    
    private func setupAuthorLabel() {
        authorLabel.font = .systemFont(ofSize: 14, weight: .medium)
        authorLabel.textColor = .secondaryLabel
        
        view.addSubview(authorLabel)
        authorLabel.pin(to: view, [.left: 16, .right: 16])
        authorLabel.pinTop(to: newsPublishedAtLabel.bottomAnchor, 10)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: NewsViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        urlButton.setTitle(viewModel.url, for: .normal)
        newsPublishedAtLabel.text = "Published at: \(viewModel.publishedAt)"
        let authorText = viewModel.author ?? ""
        if authorText != "" {
            authorLabel.text = "Author: \(authorText)"
        }
        if let data = viewModel.imageData {
            imageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func incrementView(viewModel: NewsViewModel) {
        viewModel.viewsCount += 1
    }
    
    // MARK: - Objc functions
    @objc
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func urlButtonPressed() {
        let text = urlButton.titleLabel?.text
        guard let myURL = URL(string: text ?? "https://www.apple.com") else {
            return
        }
        let vc = WebViewController(url: myURL)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
        
    }
}

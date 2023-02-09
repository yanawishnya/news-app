//
//  NewsCell.swift
//  News
//
//  Created by Барбашина Яна on 05.02.2023.
//

import UIKit

class NewsCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    private let newsViewsLabel = UILabel()
    private var imageCache = NSCache<NSString, UIImage>()
    private var titleCache = NSCache<NSString, NSString>()
    private var descriptionCache = NSCache<NSString, NSString>()
    private var viewsCache = NSCache<NSString, NSNumber>()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupViewsLabel()
    }
    
    private func setupImageView() {
        newsImageView.image = UIImage(named: "landscape")
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(newsImageView)
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:
                                                16).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:
                                                -12).isActive = true
        newsImageView.pinWidth(to: newsImageView.heightAnchor)
    }
    
    private func setupTitleLabel() {
        newsTitleLabel.text = "Hello"
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 1
        
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.heightAnchor.constraint(equalToConstant:
        newsTitleLabel.font.lineHeight).isActive = true
        
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant:
                                                    12).isActive = true
        newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:
                                                    -12).isActive = true
    }
    
    private func setupDescriptionLabel() {
        newsDescriptionLabel.text = "World"
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 0
        
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor,
                                                      constant: 12).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant:
                                                    8).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -16).isActive = true
        newsDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                     constant: -30).isActive = true
    }
    
    private func setupViewsLabel() {
        newsViewsLabel.text = "viewed: 0 times"
        newsViewsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsViewsLabel.textColor = .secondaryLabel
        
        contentView.addSubview(newsViewsLabel)
        newsViewsLabel.translatesAutoresizingMaskIntoConstraints = false
        newsViewsLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor,
                                                      constant: 12).isActive = true
        newsViewsLabel.topAnchor.constraint(equalTo: newsDescriptionLabel.bottomAnchor, constant:
                                                    8).isActive = true
        newsViewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -16).isActive = true
        newsViewsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                     constant: -10).isActive = true
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: NewsViewModel) {
        let urlString = viewModel.url ?? ""
        
        configureTitle(url: urlString, viewModel: viewModel)
        configureDescription(url: urlString, viewModel: viewModel)
        configureViewsCount(url: urlString, viewModel: viewModel)
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            newsImageView.image = cachedImage
        }
        else if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
            self.imageCache.setObject(newsImageView.image ?? UIImage(), forKey: urlString as NSString)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
            self.imageCache.setObject(newsImageView.image ?? UIImage(), forKey: urlString as NSString)
        }
        
    }
    
    private func configureTitle(url: String, viewModel: NewsViewModel) {
        if let cachedTitle = titleCache.object(forKey: url as NSString) {
            newsTitleLabel.text = cachedTitle as String?
        }
        else {
            newsTitleLabel.text = viewModel.title
            let newsTitle = newsTitleLabel.text ?? ""
            self.titleCache.setObject(newsTitle as NSString, forKey: url as NSString)
        }
    }
    
    private func configureDescription(url: String, viewModel: NewsViewModel) {
        if let cachedDescription = descriptionCache.object(forKey: url as NSString) {
            newsDescriptionLabel.text = cachedDescription as String?
        }
        else {
            newsDescriptionLabel.text = viewModel.description
            let newsDescription = newsDescriptionLabel.text ?? ""
            self.descriptionCache.setObject(newsDescription as NSString, forKey: url as NSString)
        }
    }
    
    private func configureViewsCount(url: String, viewModel: NewsViewModel) {
        if let cachedViews = viewsCache.object(forKey: url as NSString) {
            newsViewsLabel.text = "Viewed \(cachedViews.intValue) times"
        }
        else {
            newsViewsLabel.text = "Viewed \(viewModel.viewsCount) times"
            self.viewsCache.setObject(viewModel.viewsCount as NSNumber, forKey: url as NSString)
        }
    }
}

//
//  WebViewController.swift
//  News
//
//  Created by Барбашина Яна on 05.02.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func configure() {
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
        configureButtons()
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                                                    title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(didDoneTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                                                    barButtonSystemItem: .refresh,
                                                    target: self,
                                                    action: #selector(didRefreshTapped))
    }
    
    @objc
    private func didDoneTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didRefreshTapped() {
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        print("Webview did fail load with error: \(error)")

        let alert = UIAlertController(title: "No internet connection", message: "Check your internet connection and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

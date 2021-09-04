//
//  WebViewController.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import WebKit

public class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //process WKScriptMessage
    }
}

public class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    public let webView: WKWebView
    public private(set) var url: URL
    public lazy var progressView: UIProgressView = UIProgressView(progressViewStyle: .default)

    deinit {
        removeObservers()
    }

    public init(url: URL) {
        self.url = url
        let userContentController = WKUserContentController()
        let handler = ScriptMessageHandler()
        userContentController.add(handler, name: "name")
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false

        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
        load(with: url)

        progressView.isHidden = true
        progressView.progressTintColor = UIColor(red: 22/255.0, green: 126/255.0, blue: 251/255.0, alpha: 1)
        view.addSubview(progressView)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = view.bounds
        progressView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 2)
    }

    func load(with url: URL) {
        self.url = url
        let request = URLRequest(url: url)
        webView.load(request)
    }

    //MARK: WKUIDelegate/WKNavigationDelegate
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let urlString = navigationAction.request.url?.absoluteString, let url = URL(string: urlString) {
            let vc = WebViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
        return nil
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //if navigationAction.request.url 是跳转链接，decisionHandler(.cancel)
         decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard let error = error as NSError? else {
            return
        }
        if error.code == NSURLErrorCancelled {
            return
        }
        //show error tips
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let error = error as NSError? else {
            return
        }
        if error.code == NSURLErrorCancelled {
            return
        }
        //show error tips
    }

    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                let card = URLCredential.init(trust: trust)
                completionHandler(.useCredential, card)
            }else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }

    //MARK: - KVO
    func addObservers() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    func removeObservers() {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            guard let doubleValue = change?[NSKeyValueChangeKey.newKey] as? Double else {
                return
            }
            let progress = Float(doubleValue)
            if progressView.isHidden == true {
                progressView.setProgress(0, animated: false)
                progressView.isHidden = false
                progressView.alpha = 1
            }
            progressView.setProgress(progress, animated: true)
            if progress >= 1 {
                UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressView.alpha = 0
                }) { (finished) in
                    self.progressView.isHidden = true
                }
            }
        }
    }
}

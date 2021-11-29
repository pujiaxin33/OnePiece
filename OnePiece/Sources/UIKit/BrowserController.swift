//
//  WebViewController.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import WebKit

/// 只是样板代码，不能直接使用，需要自行修改。
open class BrowserController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    public let webView: WKWebView
    public private(set) var currentURL: URL
    
    lazy var progressView: UIProgressView = {
        let progressLine = UIProgressView(progressViewStyle: .default)
        progressLine.isHidden = true
        progressLine.progressTintColor = .blue
        progressLine.trackTintColor = .lightGray
        progressLine.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 2)
        self.view.addSubview(progressLine)
        return progressLine
    }()
    
    deinit {
        self.removeObservers()
    }
    
    public init(url: URL) {
        self.currentURL = url
        
        let userContentController = WKUserContentController()
        let messageHandler = ScriptMessageHandler()
        userContentController.add(messageHandler, name: "name")

        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: config)
        messageHandler.webView = webView
        
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.view.addSubview(webView)
        
        _ = webView.load(makeRequest())
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }
    
    open func reload(with url: URL) {
        self.currentURL = url
        _ = webView.load(makeRequest())
    }
    
    func dealNavigationAction(navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if self.canOpenInNative(with: url) == true {
            decisionHandler(.cancel)
        }else {
            if url.scheme != "http" && url.scheme != "https" && url.scheme != "about" {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    print("can`t open url:\(url)")
                }
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }
    
    func dealNavigationResponse(navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func canOpenInNative(with url: URL) -> Bool {
        if url.scheme == ApplicationURLScheme && url.host == ApplicationURLHost {
            //在native页面中打开browser
            if url.path == "/webview" && url.query?.contains("org_url") == true {
                var targetURLString: String?
                if let components = url.query?.components(separatedBy: "&") {
                    for item in components {
                        if item.contains("org_url") {
                            let param = item.components(separatedBy: "=")
                            targetURLString = param.last
                        }
                    }
                }
                targetURLString = targetURLString?.removingPercentEncoding
                targetURLString = targetURLString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let targetURLString = targetURLString, let url = URL(string: targetURLString) {
                    let vc = BrowserController(url: url)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return true
            } else {
                //跳转到具体某个native页面
                try? SchemeManager.openURL(url, self)
                return true
            }
        }
        else if(url.absoluteString.contains("http://no_return/"))
        {
            self.dismiss(animated: true,completion: nil)
            return true
        }
        return false
    }
    
    open func makeRequest() -> URLRequest {
        var request = URLRequest.init(url: currentURL)
        request.cachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
        return request
    }
}

//MARK: - KVO
extension BrowserController {
    func addObservers() {
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func removeObservers() {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            guard let progress = change?[NSKeyValueChangeKey.newKey] as? Double else {
                return
            }
            if progressView.isHidden == true {
                progressView.isHidden = false
                progressView.alpha = 1
            }
            progressView.setProgress(Float(progress), animated: true)
            if progress >= 1.0 {
                UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressView.alpha = 0
                }) { (finished) in
                    self.progressView.isHidden = true
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

//MARK: WKUIDelegate/WKNavigationDelegate
extension BrowserController {
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url {
            let vc = BrowserController(url: url)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return nil
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        dealNavigationAction(navigationAction: navigationAction, decisionHandler: decisionHandler)
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        dealNavigationResponse(navigationResponse: navigationResponse, decisionHandler: decisionHandler)
    }
    
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let ocError = error as NSError
        if ocError.code == NSURLErrorCancelled {
            return
        }
        //handle error
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let ocError = error as NSError
        if ocError.code == NSURLErrorCancelled {
            return
        }
        //handle error
    }
    
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                let card = URLCredential.init(trust: trust)
                completionHandler(.useCredential, card)
            }else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    //show webview alert box
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))

        present(alertController, animated: true, completion: nil)
    }


    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        present(alertController, animated: true, completion: nil)
    }


    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .actionSheet)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension BrowserController: SchemeTargetPage {
    public static func page(with info: SchemeInfo) -> UIViewController? {
        guard let urlString = info.params?["url"], let url = URL(string: urlString) else {
            return nil
        }
        return BrowserController(url: url)
    }
}

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var webView: WKWebView?

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }
}


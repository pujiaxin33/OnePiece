//
//  SchemeManager.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public let ApplicationURLScheme: String = "xx"
public let ApplicationURLHost: String = "www.xx.com"

public enum SchemePath: String {
    case webview = "/webview"
}

public class SchemeInfo {
    public let originUrl: URL
    public let scheme: String?
    public let host: String?
    public let path: String
    public let params: [String: String]?

    public init(url: URL) {
        self.originUrl = url
        self.path = originUrl.path
        self.scheme = originUrl.scheme
        self.host = originUrl.host
        if let urlComponents = NSURLComponents(string: url.absoluteString), let queryItems = urlComponents.queryItems {
            var parameters = [String: String]()
            queryItems.forEach { parameters[$0.name] = $0.value }
            self.params = parameters
        }else {
            self.params = nil
        }
    }
}

public enum SchemeError: Error {
    case unsupport
    case notFoundSourcePage
    case notFoundTargetPage
    case sourcePageDontHaveNavi
    case sourceTargetSame
}

public protocol SchemeTargetPage: class {
    static func page(with info: SchemeInfo) -> UIViewController?
}

public class SchemeManager {
    public class func openPath(_ path: SchemePath) throws {
        try openURL(shemeURL(with: path))
    }

    public class func openURL(_ url: URL, _ sourcePage: UIViewController? = nil) throws {
        let url = compatibleURL(url)
        guard canOpenInApplication(url) else {
            //非应用支持的跳转协议
            throw SchemeError.unsupport
        }
        guard let sourcePage = sourcePage ?? SchemeManager.sourcePage() else {
            //没有找到起跳页面
            throw SchemeError.notFoundSourcePage
        }
        guard let targetPage = targetPage(url) else {
            //没有找到落地页面
            throw SchemeError.notFoundTargetPage
        }
        guard let navigationController = sourcePage.navigationController else {
            //起跳页面没有导航栏控制器
            throw SchemeError.sourcePageDontHaveNavi
        }
        if sourcePage.isKind(of: type(of: targetPage)) && targetPage.isKind(of: UIViewController.self) == false {
            //起跳页面和落地页面是同一个页面类，并且不是浏览器的页面，不允许跳转。
            throw SchemeError.sourceTargetSame
        }
        guard navigationController.presentedViewController != nil else {
            //当前有被模态推送的页面，需要先dismiss掉，然后再push。
            navigationController.dismiss(animated: true, completion: {
                navigationController.pushViewController(targetPage, animated: true)
            })
            return
        }
        navigationController.pushViewController(targetPage, animated: true)
    }

    private class func canOpenInApplication(_ url: URL) -> Bool {
        guard let scheme = url.scheme else {
            return false
        }
        let validSchemes = [ApplicationURLScheme, "http", "https"]
        return validSchemes.contains(scheme)
    }

    private class func compatibleURL(_ url: URL) -> URL {
        if checkWebScheme(url.scheme) {
            let prefix = shemeURL(with: .webview).absoluteString
            return URL(string: "\(prefix)?url=\(url.absoluteString)")!
        }
        return url
    }
}

extension SchemeManager {
    public class func shemeURL(with path: SchemePath) -> URL {
        let urlString = "\(ApplicationURLScheme)://\(ApplicationURLHost)\(path.rawValue)"
        return URL(string: urlString)!
    }

    public class func sourcePage() -> UIViewController? {
        let rootVC = UIApplication.shared.delegate?.window??.rootViewController
        guard let tabVC = rootVC as? UITabBarController else {
            return nil
        }
        guard let naviVC = tabVC.selectedViewController as? UINavigationController else {
            return nil
        }
        return naviVC.viewControllers.last
    }

    public class func targetPage(_ url: URL) -> UIViewController? {
        guard let path = schemePath(with: url) else {
            return nil
        }
        let pageName = className(with: path)
        guard let classValue = classFromString(pageName) else {
            return nil
        }
        guard let page = classValue as? SchemeTargetPage.Type else {
            return nil
        }
        return page.page(with: SchemeInfo.init(url: url))
    }

    private class func schemePath(with url: URL) -> SchemePath? {
        if checkWebScheme(url.scheme) {
            return .webview
        }else if url.scheme == ApplicationURLScheme {
            return SchemePath(rawValue: url.path)
        }
        return nil
    }

    private class func checkWebScheme(_ scheme: String?) -> Bool {
        if scheme == "http" || scheme == "https" {
            return true
        }
        return false
    }

    private class func className(with path: SchemePath) -> String {
        switch path {
        case .webview: return "BrowserController"
        }
    }

    private class func classFromString(_ string: String) -> AnyClass? {
        if let classValue = NSClassFromString(string) {
            return classValue
        }
        guard let bundlePrefix = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        if let classValue = NSClassFromString("\(bundlePrefix).\(string)") {
            return classValue
        }
        return nil
    }
}

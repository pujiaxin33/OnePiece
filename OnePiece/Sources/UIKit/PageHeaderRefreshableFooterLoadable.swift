//
//  PageHeaderRefreshableFooterLoadable.swift
//  OnePiece
//
//  Created by tony on 2021/12/14.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

public protocol PageHeaderRefreshable: AnyObject {
    func pageScrollView() -> UIScrollView
    func setupHeader()
    func processHeaderRefresh()
    func startHeaderRefreshing()
    func endHeaderRefreshing()
}
public extension PageHeaderRefreshable {
    func setupHeader() {
//        let header = PageRefreshHeader.init(refreshingBlock: {[weak self] in
//            self?.processHeaderRefresh()
//        })
//        pageScrollView().mj_header = header
    }
    func startHeaderRefreshing() {
//        pageScrollView().mj_header?.beginRefreshing()
    }
    func endHeaderRefreshing() {
//        pageScrollView().mj_header?.endRefreshing()
    }
}

public protocol PageFooterLoadable: AnyObject {
    var currentPageIndex: Int { set get }
    func pageSize() -> Int
    func pageScrollView() -> UIScrollView
    func setupFooter()
    func processFooterLoad()
    func startFooterLoad()
    func endFooterLoad()
    func hideFooterIfNeeded(_ count: Int)
}
extension PageFooterLoadable {
    func pageSize() -> Int {
        return NumberResource.pageSize
    }
    func setupFooter() {
//        let footer = MJRefreshBackGifFooter.init(refreshingBlock: {[weak self] in
//            self?.processFooterLoad()
//        })
//        footer.stateLabel?.textColor = .fromHex(0x919191)
//        footer.setImages([UIImage(named: "common_footer_load_tips")!, UIImage(named: "common_footer_load_tips")!], for: .idle)
//        footer.setImages([], for: .noMoreData)
//        footer.setTitle("", for: .noMoreData)
//        pageScrollView().mj_footer = footer
    }
    func startFooterLoad() {
//        pageScrollView().mj_footer?.beginRefreshing()
    }
    func endFooterLoad() {
//        pageScrollView().mj_footer?.endRefreshing()
    }
    func hideFooterIfNeeded(_ count: Int) {
//        if count >= pageSize() {
//            currentPageIndex += 1
//            pageScrollView().mj_footer?.endRefreshing()
//        }else {
//            pageScrollView().mj_footer?.endRefreshingWithNoMoreData()
//        }
    }
}
public typealias PageHeaderRefreshableFooterLoadable = PageHeaderRefreshable & PageFooterLoadable

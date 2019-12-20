//
//  ImageGuideViewController.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

public class ImageGuideViewController: UIViewController {
    private lazy var window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    private lazy var pageControl: UIPageControl = UIPageControl()
    private lazy var scrollView: UIScrollView = UIScrollView()
    private let images: [UIImage]
    private lazy var imageViews = [UIImageView]()

    public init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)

        window.rootViewController = self
        window.windowLevel = UIWindow.Level.statusBar - 1
        window.isHidden = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)

        for image in images {
            let imageView = UIImageView(image: image)
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }

        let confirmButton = UIButton(type: .custom)
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked(btn:)), for: .touchUpInside)
        confirmButton.setTitle("跳过", for: .normal)
        confirmButton.layer.cornerRadius = 15
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.layer.borderWidth = 1/UIScreen.main.scale
        view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true

        pageControl.numberOfPages = images.count
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(images.count), height: scrollView.bounds.size.height)
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(x: scrollView.bounds.size.width*CGFloat(index), y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        }
    }

    @objc func confirmButtonClicked(btn: UIButton) {
        dismiss()
    }

    public func show() {
        window.isHidden = false
    }

    public func dismiss() {
        self.window.isHidden = true
        self.window.rootViewController = nil
    }
}

extension ImageGuideViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x/view.bounds.size.width)
    }
}


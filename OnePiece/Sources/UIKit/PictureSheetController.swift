//
//  PictureSheetController.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

public typealias UIImagePickerSourceViewController = UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate

public class LoadPictureSheetController: UIAlertController {
    public convenience init(title: String?,
                            message: String?,
                            sourceVC: UIImagePickerSourceViewController,
                            allowsEditing: Bool = false,
                            takePhoneTitle: String = "拍照",
                            photoAlbumTitle: String = "相册",
                            cancelTitle: String = "取消") {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        addAction(.init(title: takePhoneTitle, style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.modalPresentationStyle = .fullScreen
            picker.sourceType = .camera
            picker.delegate = sourceVC
            picker.allowsEditing = allowsEditing
            sourceVC.present(picker, animated: true, completion: nil)
        }))
        addAction(.init(title: photoAlbumTitle, style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.modalPresentationStyle = .fullScreen
            picker.sourceType = .photoLibrary
            picker.delegate = sourceVC
            picker.allowsEditing = allowsEditing
            sourceVC.present(picker, animated: true, completion: nil)
        }))
        addAction(.init(title: cancelTitle, style: .cancel, handler: nil))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

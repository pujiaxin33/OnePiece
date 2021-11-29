//
//  PickerView.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import UIKit
//import JXPopupView

class PickerItemModel {
    var data: Any?
    var title: String?
    var elements: [PickerItemModel]?

    init(data: Any?, title: String?, elements: [PickerItemModel]?) {
        self.data = data
        self.title = title
        self.elements = elements
    }
}

class PickerPopupView: UIView {
    var cancelCallback: (()->())?
    var confirmCallback: (()->())?
    let pickerView: UIView
    lazy var toolbar = UIToolbar()
    
    override var intrinsicContentSize: CGSize {
        var safeBottomEdge: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeBottomEdge = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return .init(width: UIScreen.main.bounds.size.width, height: preferredToolbarHeight() + preferredPickerHeight() + safeBottomEdge)
    }

    init(pickerView: UIView) {
        self.pickerView = pickerView
        super.init(frame: CGRect.zero)
        
        backgroundColor = .white

        toolbar.barStyle = .black
        toolbar.isTranslucent = false
        toolbar.barTintColor = .white
        addSubview(toolbar)

        let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        cancelItem.tintColor = preferredCancelTintColor()
        cancelItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        let confirmItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(confirm))
        confirmItem.tintColor = preferredConfirmTintColor()
        confirmItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let edgeItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        edgeItem.width = 20
        toolbar.items = [edgeItem, cancelItem, flexibleItem, confirmItem, edgeItem]

        addSubview(pickerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        toolbar.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height:  preferredToolbarHeight())
        pickerView.frame = CGRect(x: 0, y: toolbar.frame.maxY, width: bounds.size.width, height: preferredPickerHeight())
    }

    func show(in view: UIView, isDismissible: Bool = true, completion: (()->())? = nil) {
//        let popupView = PopupView(containerView: view, contentView: self, animator: UpwardAnimator(layout: .bottom(.init())))
//        popupView.isDismissible = isDismissible
//        popupView.display(animated: true, completion: completion)
    }

    func preferredCancelTintColor() -> UIColor {
        return .gray
    }

    func preferredConfirmTintColor() -> UIColor {
        return .black
    }
    func preferredToolbarHeight() -> CGFloat {
        42
    }
    func preferredPickerHeight() -> CGFloat {
        167
    }

    @objc func cancel() {
        cancelCallback?()
//        popupView()?.dismiss(animated: true, completion: nil)
    }

    @objc func confirm() {
        confirmCallback?()
//        popupView()?.dismiss(animated: true, completion: nil)
    }

}

class TextPickerPopupView: PickerPopupView {
    var confirmItemsCallback: (([PickerItemModel]) -> Void)?
    var defaultSelectedItems: [PickerItemModel]? {
        didSet {
            if let selectedItems = defaultSelectedItems {
                var currentItems: [PickerItemModel]? = dataSource
                for (component, selectedItem) in selectedItems.enumerated() {
                    guard let row = currentItems?.firstIndex(where: { (sub) -> Bool in
                        return sub.title == selectedItem.title
                    }) else {
                        continue
                    }
                    selectedRecord[component] = row
                    currentItems = currentItems?[row].elements
                }
            }
        }
    }
    let picker: UIPickerView
    private let dataSource: [PickerItemModel]
    let componentsCount: Int
    private var isDefaultSeletedItemsSetup = false
    private var selectedRecord: [Int : Int] = [:]

    init(dataSource: [PickerItemModel]) {
        self.dataSource = dataSource
        self.picker = UIPickerView()
        var item = dataSource.first
        var count = 0
        while item != nil {
            item = item?.elements?.first
            count += 1
        }
        self.componentsCount = count
        super.init(pickerView: self.picker)

//        toolbar.addBottomBorder(lineWidth: LineWidth, lineColor: .black)


        picker.dataSource = self
        picker.delegate = self
        toolbar.barTintColor = .white
        picker.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !isDefaultSeletedItemsSetup {
            isDefaultSeletedItemsSetup = true
            for (component, row) in selectedRecord {
                picker.selectRow(row, inComponent: component, animated: false)
            }
            picker.reloadAllComponents()
        }
    }

    func items(component: Int) -> [PickerItemModel]? {
        if component == 0 {
            return dataSource
        }
        var models: [PickerItemModel]? = dataSource
        for level in 1...component {
            models = models?[selectedRecord[level - 1] ?? 0].elements
        }
        return models
    }

    override func confirm() {
        super.confirm()

        var result = [PickerItemModel]()
        for index in 0..<componentsCount {
            if let model = items(component: index)?[picker.selectedRow(inComponent: index)] {
                result.append(model)
            }
        }
        confirmItemsCallback?(result)
    }
}

extension TextPickerPopupView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentsCount
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items(component: component)?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let elements = items(component: component), row < elements.count, let title = elements[row].title else {
            return NSAttributedString(string: "")
        }
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRecord[component] = row
        //重置后面component记录的row
        for (key, _) in selectedRecord {
            if key > component {
                selectedRecord[key] = 0
            }
        }
        if component < componentsCount - 1 {
            //当前选中的不是最后一个，将后续的component选中第一个
            for index in (component + 1)..<componentsCount {
                picker.selectRow(0, inComponent: index, animated: false)
            }
            picker.reloadAllComponents()
        }
    }
}



protocol PickerItemContent {
    func title() -> String?
    func elements() -> [PickerItemContent]?
}

class PickerManager {
    class func items(content: [PickerItemContent]) -> [PickerItemModel] {
        var result = [PickerItemModel]()
        for model in content {
            let elements = model.elements()
            let item = PickerItemModel(data: model, title: model.title(), elements: elements != nil ? items(content: elements!) : nil)
            result.append(item)
        }
        return result
    }
}

class DatePickerPopupView: PickerPopupView {
    let picker: UIDatePicker
    var defaultDate: Date?
    var confirmDateCallback: ((Date)->())?
    private var isDefaultDateSetup = false

    init(minimumDate: Date? = nil, maximumDate: Date? = nil) {
        self.picker = UIDatePicker()
        super.init(pickerView: picker)

        picker.minimumDate = minimumDate
        picker.maximumDate = maximumDate
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !isDefaultDateSetup, let date = defaultDate {
            isDefaultDateSetup = true
            picker.date = date
        }
    }

    override func confirm() {
        super.confirm()

        confirmDateCallback?(picker.date)
    }
}


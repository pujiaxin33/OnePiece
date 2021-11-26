//
//  AnyBuilder.swift
//  OnePiece
//
//  Created by tony on 2021/11/26.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation

@resultBuilder
public enum AnyBuilder<BuilderItem> {
    public static func buildExpression(_ expression: BuilderItem) -> [BuilderItem] {
        return [expression]
    }
    public static func buildExpression<Data: RandomAccessCollection>(_ expression: ForEach<Data, BuilderItem>) -> [BuilderItem] {
        return expression.items
    }
    public static func buildExpression(_ expression: ()) -> [BuilderItem] {
        return []
    }
    public static func buildBlock(_ components: [BuilderItem]...) -> [BuilderItem] {
        return components.flatMap { $0 }
    }
    public static func buildBlock(_ components: BuilderItem...) -> [BuilderItem] {
        return components.map { $0 }
    }
    public static func buildIf(_ component: [BuilderItem]?) -> [BuilderItem] {
        return component ?? []
    }
    public static func buildEither(first component: [BuilderItem]) -> [BuilderItem] {
        return component
    }
    public static func buildEither(second component: [BuilderItem]) -> [BuilderItem] {
        return component
    }
    public static func buildArray(_ components: [[BuilderItem]]) -> [BuilderItem] {
        Array(components.joined())
    }
}

public class ForEach<Data, Item> where Data : RandomAccessCollection {
    let data: Data
    let items: [Item]
    public init(_ data: Data, @AnyBuilder<Item> itemsProvider: @escaping (Data.Element) -> [Item]) {
        self.data = data
        var result = [Item]()
        for dataItem in data {
            let itemsArray = itemsProvider(dataItem)
            result.append(contentsOf: itemsArray)
        }
        self.items = result
    }
}

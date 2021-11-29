//
//  AnyBuilder.swift
//  OnePiece
//
//  Created by tony on 2021/11/26.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation

@resultBuilder
public enum AnyBuilder<Expression> {
    public typealias Component = [Expression]
    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }
    public static func buildExpression<Data: RandomAccessCollection>(_ expression: ForEach<Data, Expression>) -> Component {
        return expression.items
    }
    public static func buildExpression(_ expression: ()) -> Component {
        return []
    }
    public static func buildBlock(_ components: Component...) -> Component {
        return components.flatMap { $0 }
    }
    public static func buildBlock(_ components: Expression...) -> Component {
        return components.map { $0 }
    }
    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? []
    }
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    public static func buildArray(_ components: [Component]) -> Component {
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

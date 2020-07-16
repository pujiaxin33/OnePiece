//
//  UserDefaults.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public struct UserDefaultsKey {
}

public extension UserDefaults {
    func string(forKey defaultName: String, defaultValue: @autoclosure () -> String) -> String {
        if let value = string(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func array(forKey defaultName: String, defaultValue: @autoclosure () -> [Any]) -> [Any] {
        if let value = array(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func dictionary(forKey defaultName: String, defaultValue: @autoclosure () -> [String : Any]) -> [String : Any] {
        if let value = dictionary(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func data(forKey defaultName: String, defaultValue: @autoclosure () -> Data) -> Data {
        if let value = data(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func stringArray(forKey defaultName: String, defaultValue: @autoclosure () -> [String]) -> [String] {
        if let value = stringArray(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func integer(forKey defaultName: String, defaultValue: @autoclosure () -> Int) -> Int {
        if object(forKey: defaultName) != nil {
            return integer(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func float(forKey defaultName: String, defaultValue: @autoclosure () -> Float) -> Float {
        if object(forKey: defaultName) != nil {
            return float(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func double(forKey defaultName: String, defaultValue: @autoclosure () -> Double) -> Double {
        if object(forKey: defaultName) != nil {
            return double(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func bool(forKey defaultName: String, defaultValue: @autoclosure () -> Bool) -> Bool {
        if object(forKey: defaultName) != nil {
            return bool(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func url(forKey defaultName: String, defaultValue: @autoclosure () -> URL) -> URL {
        if let value = url(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
}

protocol OptionalTypeCheck {
    var isNil: Bool { get }
}

public protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }

    static var empty: Self { get }
}

extension Optional: OptionalType, OptionalTypeCheck {

    public var wrapped: Wrapped? {
        return self
    }

    public static var empty: Optional {
        return nil
    }

    var isNil: Bool {
        return self == nil
    }
}

extension DefaultsSerializable {
    public static var _defaultsArray: DefaultsArrayBridge<[T]> { return DefaultsArrayBridge() }
}
extension Date: DefaultsSerializable {
    public static var _defaults: DefaultsObjectBridge<Date> { return DefaultsObjectBridge() }
}
extension String: DefaultsSerializable {
    public static var _defaults: DefaultsStringBridge { return DefaultsStringBridge() }
}
extension Int: DefaultsSerializable {
    public static var _defaults: DefaultsIntBridge { return DefaultsIntBridge() }
}
extension Double: DefaultsSerializable {
    public static var _defaults: DefaultsDoubleBridge { return DefaultsDoubleBridge() }
}
extension Bool: DefaultsSerializable {
    public static var _defaults: DefaultsBoolBridge { return DefaultsBoolBridge() }
}
extension Data: DefaultsSerializable {
    public static var _defaults: DefaultsDataBridge { return DefaultsDataBridge() }
}

extension URL: DefaultsSerializable {
    public static var _defaults: DefaultsUrlBridge { return DefaultsUrlBridge() }
    public static var _defaultsArray: DefaultsKeyedArchiverBridge<[URL]> { return DefaultsKeyedArchiverBridge() }
}

extension Dictionary: DefaultsSerializable where Key == String {
    public typealias T = [Key: Value]
    public typealias Bridge = DefaultsObjectBridge<T>
    public static var _defaults: Bridge { return Bridge() }
}
extension Array: DefaultsSerializable where Element: DefaultsSerializable {
    public typealias T = [Element.T]
    public typealias Bridge = Element.Bridge
    public static var _defaults: Bridge {
        return Element._defaults
    }
}

extension Optional: DefaultsSerializable where Wrapped: DefaultsSerializable {
    public typealias Bridge = DefaultsOptionalBridge<Wrapped.Bridge>

    public static var _defaults: DefaultsOptionalBridge<Wrapped.Bridge> { return DefaultsOptionalBridge(bridge: Wrapped._defaults) }
}

public protocol DefaultsBridge {

    associatedtype T

    /// This method provides a way of saving your data in UserDefaults. Usually needed
    /// when you want to create your custom Bridge, so you'll have to override it.
    func get(key: String, userDefaults: UserDefaults) -> T?

    /// This method provides a way of saving your data in UserDefaults. Usually needed
    /// when you want to create your custom Bridge, so you'll have to override it.
    func save(key: String, value: T?, userDefaults: UserDefaults)

    /// Override this function if your data is represented differently in UserDefaults
    /// and you map it in save/get methods.
    ///
    /// For instance, if you store it as Data in UserDefaults, but your type is not Data in your
    /// defaults key, then you need to provide `deserialize(_:)` method as well.
    ///
    /// Similar if you store your array of type as e.g. `[String]` but the type you use is actually `[SomeClassThatHasOnlyOneStringProperty]`.
    ///
    /// See `DefaultsRawRepresentableBridge` or `DefaultsCodableBridge` for examples.
    func deserialize(_ object: Any) -> T?
}

public protocol DefaultsSerializable {
    // swiftlint:disable:next type_name
    typealias T = Bridge.T
    associatedtype Bridge: DefaultsBridge

    static var _defaults: Bridge { get }
}

public struct DefaultsStringBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: String?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> String? {
        return userDefaults.string(forKey: key)
    }

    public func deserialize(_ object: Any) -> String? {
        return nil
    }
}

public extension UserDefaults {

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T.T where T: OptionalType, T.T == T {
        get {
            if let value = T._defaults.get(key: key._key, userDefaults: self), let _value = value as? T.T.Wrapped {
                // swiftlint:disable:next force_cast
                return _value as! T
            } else if let defaultValue = key.defaultValue {
                return defaultValue
            } else {
                return T.T.empty
            }
        }
        set {
            T._defaults.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T.T where T.T == T {
        get {
            if let value = T._defaults.get(key: key._key, userDefaults: self) {
                return value
            } else if let defaultValue = key.defaultValue {
                return defaultValue
            } else {
                fatalError("Shouldn't happen, please report!")
            }
        }
        set {
            T._defaults.save(key: key._key, value: newValue, userDefaults: self)
        }
    }
}

public struct DefaultsKey<ValueType: DefaultsSerializable> {
    let _key: String
    var defaultValue: ValueType.T?

    public init(key: String, defaultValue: ValueType.T) {
        self._key = key
        self.defaultValue = defaultValue
    }

    private init(key: String) {
        self._key = key
        self.defaultValue = nil
    }
}

public extension DefaultsKey where ValueType: DefaultsSerializable, ValueType: OptionalType, ValueType.Wrapped: DefaultsSerializable {

    init(_ key: String) {
        self.init(key: key)
    }

    init(_ key: String, defaultValue: ValueType.T) {
        self._key = key
        self.defaultValue = defaultValue
    }
}


public struct DefaultsAdapter {
    public let defaults: UserDefaults
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

public extension DefaultsAdapter {
    subscript<T: DefaultsSerializable>(key key: DefaultsKey<T>) -> T.T where T: OptionalType, T.T == T {
        get {
            return defaults[key]
        }
        set {
            defaults[key] = newValue
        }
    }

    subscript<T: DefaultsSerializable>(_ key: DefaultsKey<T>) -> T.T where T.T == T {
        get {
            return defaults[key]
        }
        set {
            defaults[key] = newValue
        }
    }
}

public var Defaults = DefaultsAdapter(defaults: .standard)

public struct DefaultsObjectBridge<T>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.object(forKey: key) as? T
    }

    public func deserialize(_ object: Any) -> T? {
        return nil
    }
}

public struct DefaultsArrayBridge<T: Collection>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.array(forKey: key) as? T
    }

    public func deserialize(_ object: Any) -> T? {
        return nil
    }
}

public struct DefaultsIntBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Int?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Int? {
        if let int = userDefaults.number(forKey: key)?.intValue {
            return int
        }

        // Fallback for launch arguments
        if let string = userDefaults.object(forKey: key) as? String,
            let int = Int(string) {
            return int
        }

        return nil
    }

    public func deserialize(_ object: Any) -> Int? {
        return nil
    }
}

public struct DefaultsDoubleBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Double?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Double? {
        if let double = userDefaults.number(forKey: key)?.doubleValue {
            return double
        }

        // Fallback for launch arguments
        if let string = userDefaults.object(forKey: key) as? String,
            let double = Double(string) {
            return double
        }

        return nil
    }

    public func deserialize(_ object: Any) -> Double? {
        return nil
    }
}

public struct DefaultsBoolBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Bool?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Bool? {
        // @warning we use number(forKey:) instead of bool(forKey:), because
        // bool(forKey:) will always return a value, even if it's not set
        //
        // Now, let's see if there is value in defaults that converts to Bool first:
        if let bool = userDefaults.number(forKey: key)?.boolValue {
            return bool
        }

        // If not, fallback for values saved in a plist (e.g. for testing)
        // For instance, few of the string("YES", "true", "NO", "false") convert to Bool from a property list
        return (userDefaults.object(forKey: key) as? String)?.bool
    }

    public func deserialize(_ object: Any) -> Bool? {
        return nil
    }
}

public struct DefaultsDataBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Data?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Data? {
        return userDefaults.data(forKey: key)
    }

    public func deserialize(_ object: Any) -> Data? {
        return nil
    }
}

public struct DefaultsUrlBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: URL?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> URL? {
        return userDefaults.url(forKey: key)
    }

    public func deserialize(_ object: Any) -> URL? {
        if let object = object as? URL {
            return object
        }

        if let object = object as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: object) as? URL
        }

        if let object = object as? NSString {
            let path = object.expandingTildeInPath
            return URL(fileURLWithPath: path)
        }

        return nil
    }
}

public struct DefaultsCodableBridge<T: Codable>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }
        userDefaults.set(encodable: value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return deserialize(data)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let data = object as? Data else { return nil }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}

public struct DefaultsKeyedArchiverBridge<T>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }
        // Needed because Quick/Nimble have min target 10.10...
        if #available(OSX 10.11, *) {
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
        } else {
            fatalError("Shouldn't really happen. We do not support macOS 10.10, if it happened to you please report your use-case on GitHub issues.")
        }
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return deserialize(data)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let data = object as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
    }
}

public struct DefaultsRawRepresentableBridge<T: RawRepresentable>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value?.rawValue, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let object = userDefaults.object(forKey: key) else { return nil }
        return deserialize(object)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let rawValue = object as? T.RawValue else { return nil }
        return T(rawValue: rawValue)
    }
}

public struct DefaultsRawRepresentableArrayBridge<T: Collection>: DefaultsBridge where T.Element: RawRepresentable {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        let raw = value?.map { $0.rawValue }
        userDefaults.set(raw, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let object = userDefaults.array(forKey: key) else { return nil }
        return deserialize(object)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let rawValue = object as? [T.Element.RawValue] else { return nil }
        return rawValue.compactMap { T.Element(rawValue: $0) } as? T
    }
}

public struct DefaultsOptionalBridge<Bridge: DefaultsBridge>: DefaultsBridge {

    public typealias T = Bridge.T?

    private let bridge: Bridge

    init(bridge: Bridge) {
        self.bridge = bridge
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return bridge.get(key: key, userDefaults: userDefaults)
    }

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        bridge.save(key: key, value: value as? Bridge.T, userDefaults: userDefaults)
    }

    public func deserialize(_ object: Any) -> T? {
        return bridge.deserialize(object)
    }
}

public struct DefaultsOptionalArrayBridge<Bridge: DefaultsBridge>: DefaultsBridge where Bridge.T: Collection {

    public typealias T = Bridge.T?

    private let bridge: Bridge

    init(bridge: Bridge) {
        self.bridge = bridge
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return bridge.get(key: key, userDefaults: userDefaults)
    }

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        bridge.save(key: key, value: value as? Bridge.T, userDefaults: userDefaults)
    }

    public func deserialize(_ object: Any) -> T? {
        return bridge.deserialize(object)
    }
}

internal extension UserDefaults {

    func number(forKey key: String) -> NSNumber? {
        return object(forKey: key) as? NSNumber
    }

    func decodable<T: Decodable>(forKey key: String) -> T? {
        guard let decodableData = data(forKey: key) else { return nil }

        return try? JSONDecoder().decode(T.self, from: decodableData)
    }

    /// Encodes passed `encodable` and saves the resulting data into the user defaults for the key `key`.
    /// Any error encoding will result in an assertion failure.
    func set<T: Encodable>(encodable: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(encodable)
            set(data, forKey: key)
        } catch {
            assertionFailure("Failure encoding encodable of type \(T.self): \(error.localizedDescription)")
        }
    }
}

internal extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}

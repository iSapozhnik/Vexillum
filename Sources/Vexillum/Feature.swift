import Foundation
#if os(iOS)
import UIKit
public typealias Color = UIColor
#else
import AppKit
public typealias Color = NSColor
#endif

/// Any of the states except `default` means that the feature has been overridden
public enum FeatureState: Int, Codable {
    case `default`
    case on
    case off
}

extension FeatureState: CustomDebugStringConvertible {
    private var description: String {
        switch self {
        case .on: return "On"
        case .off: return "Off"
        case .default: return "Default"
        }
    }
    public var debugDescription: String { description }
}

public protocol AnyFeature: NSObjectProtocol {
    var key: String { get }
    var title: String { get }
    var featureDescription: String { get }
    var enabled: Bool { get }
    var defaultState: Bool { get }
    var state: FeatureState { get set }
    var requiresRestart: Bool { get }
    var isLocal: Bool { get }
}

typealias StateChange = (Feature) -> Void

public class Feature: NSObject, AnyFeature {
    public let key: String
    public let title: String
    public let featureDescription: String
    public let requiresRestart: Bool
    public let isLocal: Bool
    
    public var enabled: Bool {
        switch state {
        case .on: return true
        case .off: return false
        case .`default`: return _defaultState
        }
    }
    
    public var defaultState: Bool { _defaultState }

    public var state: FeatureState {
        didSet {
            didChangeStateHandler?(self)
        }
    }
    
    public var stateDescription: String {
        switch state {
        case .default: return _defaultState ? "On" : "Off"
        case .on: return "On"
        case .off: return "Off"
        }
    }
    
    public var color: Color {
        switch (state, _defaultState) {
        case (.on, true): return .systemGreen
        case (.on, false): return .systemOrange
        case (.off, true): return .systemOrange
        case (.off, false): return .systemGray
        case (.default, true): return .systemGreen
        case (.default, false): return .systemGray
        }
    }
    
    var didChangeStateHandler: StateChange?
    
    private var _defaultState: Bool
    
    public init(
        key: String,
        defaultState: Bool = false,
        title: String? = nil,
        featureDescription: String = "",
        requiresRestart: Bool = false,
        isLocal: Bool = true
    ) {
        self.key = key
        self.title = title ?? key
        self.featureDescription = featureDescription
        self.requiresRestart = requiresRestart
        self.isLocal = isLocal
        _defaultState = defaultState
        state = .default
    }
    
    // Called by FeatureProvider when it gets data from remote feature flag service
    func updateDefaultState(to newState: Bool) {
        _defaultState = newState
    }
}

extension Equatable where Self: AnyFeature {
    static func ==(lhs: Self, rhs: AnyFeature) -> Bool {
        lhs.key == rhs.key
    }
}

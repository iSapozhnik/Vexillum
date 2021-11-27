import Foundation

/// Any of the states except `default` means that the feature has been overriden
public enum FeatureState: Int {
    case on
    case off
    case `default`
}

extension FeatureState: CustomDebugStringConvertible {
    public var description: String {
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
}

extension AnyFeature {
    var hash: Int { return self.key.hashValue }
}

typealias StateChange = (Feature) -> Void

public class Feature: NSObject, AnyFeature {
    public let key: String
    public let title: String
    public let featureDescription: String
    
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
    
    var didChangeStateHandler: StateChange?
    
    private var _defaultState: Bool
    
    public init(
        key: String,
        defaultState: Bool = false,
        title: String? = nil,
        featureDescription: String = ""
    ) {
        self.key = key
        self.title = title ?? key
        self.featureDescription = featureDescription
        _defaultState = defaultState
        state = .default
    }
    
    // Called by FeatureProvider when it gets data from remote feature flag service
    func updateDefaultState(to newState: Bool) {
        _defaultState = newState
    }
    
    //💛 - overriden
    //🖤 - off
    //💚 - on
    var color: String {
        switch (state, _defaultState) {
        case (.on, true): return "💛"
        case (.on, false): return "💛"
        case (.off, true): return "💛"
        case (.off, false): return "💛"
        case (.default, true): return "💚"
        case (.default, false): return "🖤"
        }
    }
}

/// Any of the states except `default` means that the feature has been overriden
enum FeatureState {
    case on
    case off
    case `default`
}

extension FeatureState: CustomDebugStringConvertible {
    var description: String {
        switch self {
        case .on: return "On"
        case .off: return "Off"
        case .default: return "Default"
        }
    }
    var debugDescription: String { description }
}

protocol AnyFeature {
    var key: String { get }
    var title: String { get }
    var description: String { get }
    var defaultState: Bool { get }
    var enabled: Bool { get }
    var state: FeatureState { get set }
}

extension AnyFeature {
    var hash: Int { return self.key.hashValue }
}

class Feature: AnyFeature {
    let key: String
    let title: String
    let description: String
    
    var enabled: Bool {
        switch state {
        case .on: return true
        case .off: return false
        case .`default`: return _defaultState
        }
    }
    
    var defaultState: Bool { _defaultState }

    var state: FeatureState
    
    private var _defaultState: Bool
    
    init(
        key: String,
        defaultState: Bool = false,
        title: String? = nil,
        description: String = ""
    ) {
        self.key = key
        self.title = title ?? key
        self.description = description
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

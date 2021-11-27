import Foundation

public protocol FeatureStoreProvider {
    func featureState(forKey key: String) -> FeatureState
    func setFeatureState(_ featureState: FeatureState, forKey key: String)
}

public enum FeatureStore {
    public static let userDefaults = UserDefaultsFeatureStore()
    public static let inMemory = InMemoryFeatureStore()
}

public final class UserDefaultsFeatureStore: FeatureStoreProvider {
    private let userDefaults = UserDefaults.standard
    
    public init() {}
    
    public func featureState(forKey key: FeatureKey) -> FeatureState {
        let featureStateIntegerValue = userDefaults.integer(forKey: key)
        guard let featureState = FeatureState(rawValue: featureStateIntegerValue) else { return .default }
        return featureState
    }
    
    public func setFeatureState(_ featureState: FeatureState, forKey key: FeatureKey) {
        userDefaults.set(featureState.rawValue, forKey: key)
    }
}

public final class InMemoryFeatureStore: FeatureStoreProvider {
    private var cache: [FeatureKey: FeatureState] = [:]
    
    public init() {}
    
    public func featureState(forKey key: FeatureKey) -> FeatureState { cache[key] ?? .default }
    public func setFeatureState(_ featureState: FeatureState, forKey key: String) { cache[key] = featureState }
}

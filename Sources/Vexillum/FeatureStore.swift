import Foundation

protocol FeatureStore {
    func featureState(forKey key: String) -> FeatureState
    func setFeatureState(_ featureState: FeatureState, forKey key: String)
}

final class UserDefaultsFeatureStore: FeatureStore {
    private let userDefaults = UserDefaults.standard
    
    func featureState(forKey key: FeatureKey) -> FeatureState {
        let featureStateIntegerValue = userDefaults.integer(forKey: key)
        guard let featureState = FeatureState(rawValue: featureStateIntegerValue) else { return .default }
        return featureState
    }
    
    func setFeatureState(_ featureState: FeatureState, forKey key: FeatureKey) {
        userDefaults.set(featureState.rawValue, forKey: key)
    }
}

final class InMemoryFeatureStore: FeatureStore {
    private var cache: [FeatureKey: FeatureState] = [:]
    
    func featureState(forKey key: FeatureKey) -> FeatureState { cache[key] ?? .default }
    func setFeatureState(_ featureState: FeatureState, forKey key: String) { cache[key] = featureState }
}

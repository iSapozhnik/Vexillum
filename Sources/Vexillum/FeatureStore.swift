import Foundation

public protocol FeatureStoreProvider {
    func featureAttributes(forKey key: FeatureKey) -> FeatureAttributes?
    func setAttributes(_ attributes: FeatureAttributes, forKey key: FeatureKey)
}

public enum FeatureStore {
    public static let userDefaults = UserDefaultsFeatureStore()
    public static let inMemory = InMemoryFeatureStore()
}

public struct FeatureAttributes: Codable {
    let state: FeatureState
    let defaultValue: Bool
}

public final class UserDefaultsFeatureStore: FeatureStoreProvider {
    private let userDefaults = UserDefaults.standard
    
    public init() {}
    
    public func featureAttributes(forKey key: FeatureKey) -> FeatureAttributes? {
        if let attributesData = userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let attributes = try? decoder.decode(FeatureAttributes.self, from: attributesData) {
                return attributes
            }
        }
        
        return nil
    }
    
    public func setAttributes(_ attributes: FeatureAttributes, forKey key: FeatureKey) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(attributes) {
            userDefaults.set(encoded, forKey: key)
        }
    }
}

public final class InMemoryFeatureStore: FeatureStoreProvider {
    private var featureAttributes: [FeatureKey: FeatureAttributes] = [:]
    
    public init() {}
    
    public func featureAttributes(forKey key: FeatureKey) -> FeatureAttributes? {
        return featureAttributes[key]
    }
    
    public func setAttributes(_ attributes: FeatureAttributes, forKey key: FeatureKey) {
        featureAttributes[key] = attributes
    }
}

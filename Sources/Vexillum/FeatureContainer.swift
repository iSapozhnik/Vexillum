import Foundation

typealias FeatureKey = String

@dynamicMemberLookup
class FeatureContainer {
    private var features: [String: AnyFeature] = [:]
    private let featureStore: FeatureStore
    
    init(featureStore: FeatureStore = UserDefaultsFeatureStore()) {
        self.featureStore = featureStore
    }

    // MARK: - Adding features
    @discardableResult
    func addFeature(_ feature: AnyFeature) throws -> Bool {
        guard !feature.key.isEmpty else { throw FeatureContainerError.featureKeyIsEmpty }
        guard features[feature.key] == nil else { throw FeatureContainerError.featureAlreadyExists(feature.key) }
        
        feature.state = featureStore.featureState(forKey: feature.key)
        features[feature.key] = feature
        
        if let feature = feature as? Feature {
            feature.didChangeStateHandler = { [weak self] updatedFeature in
                guard let self = self else { return }
                self.featureStore.setFeatureState(updatedFeature.state, forKey: updatedFeature.key)
            }
        }
        
        return true
    }
    
    @discardableResult
    func addFeatures(_ features: [AnyFeature]) throws -> Bool {
        try features.map { try addFeature($0) }.allSatisfy { $0 }
    }
    
    // MARK: - Removing features
    func removeFeature(_ feature: Feature) {
        guard let feature = features[feature.key] else { return }
        features[feature.key] = nil
    }
    
    // MARK: - Retrieving features and values (enabled or disabled)
    func featureForKey(_ key: FeatureKey) throws -> Feature {
        guard let feature = features[key] as? Feature else { throw FeatureContainerError.noFeatureFound(key) }
        return feature
    }
    
    subscript(dynamicMember member: String) -> Feature? {
        try? featureForKey(member)
    }
}

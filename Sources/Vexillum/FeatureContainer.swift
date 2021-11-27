import Foundation

public typealias FeatureKey = String

@dynamicMemberLookup
public class FeatureContainer {
    private var features: [String: AnyFeature] = [:]
    private let featureStoreProvider: FeatureStoreProvider
    
    public init(features: [AnyFeature]? = nil, featureStoreProvider: FeatureStoreProvider = UserDefaultsFeatureStore()) throws {
        self.featureStoreProvider = featureStoreProvider
        if let features = features {
            try addFeatures(features)
        }
    }

    // MARK: - Adding features
    @discardableResult
    public func addFeature(_ feature: AnyFeature) throws -> Bool {
        guard !feature.key.isEmpty else { throw FeatureContainerError.featureKeyIsEmpty }
        guard features[feature.key] == nil else { throw FeatureContainerError.featureAlreadyExists(feature.key) }
        
        feature.state = featureStoreProvider.featureState(forKey: feature.key)
        features[feature.key] = feature
        
        if let feature = feature as? Feature {
            feature.didChangeStateHandler = { [weak self] updatedFeature in
                guard let self = self else { return }
                self.featureStoreProvider.setFeatureState(updatedFeature.state, forKey: updatedFeature.key)
            }
        }
        
        return true
    }
    
    @discardableResult
    public func addFeatures(_ features: [AnyFeature]) throws -> Bool {
        try features.map { try addFeature($0) }.allSatisfy { $0 }
    }
    
    // MARK: - Removing features
    public func removeFeature(_ feature: Feature) {
        guard let feature = features[feature.key] else { return }
        features[feature.key] = nil
    }
    
    // MARK: - Retrieving features and enabled values
    public func featureForKey(_ key: FeatureKey) throws -> Feature {
        guard let feature = features[key] as? Feature else { throw FeatureContainerError.noFeatureFound(key) }
        return feature
    }
    
    private func optionalFeatureForKey(_ key: FeatureKey) -> Feature? {
        features[key] as? Feature
    }
    
    subscript(dynamicMember member: String) -> Feature? {
        try? featureForKey(member)
    }
    
    public subscript(key: FeatureKey) -> Bool {
        get {
            guard let feature = try? featureForKey(key) else { return false }
            return feature.enabled
        }
    }
    
    // MARK: - Filling feature flags with default values from remote feature flag service
    
    public func fillFromRemoteService(handler: (_ handler: @escaping ([FeatureKey: Bool]) -> Void) -> Void, completion: @escaping () -> Void) {
        handler() { featuresMap in
            featuresMap.forEach {
                if let feature = self.optionalFeatureForKey($0.key) {
                    feature.updateDefaultState(to: $0.value)
                }
            }
            completion()
        }
    }
}
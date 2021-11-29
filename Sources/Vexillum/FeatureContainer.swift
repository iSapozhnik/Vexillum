import Foundation

public typealias FeatureKey = String

@dynamicMemberLookup
public class FeatureContainer {
    public var allFeatures: [AnyFeature] { features.map { $0.value }.sorted(by: \.key) }
    
    private var features: [String: AnyFeature] = [:]
    private let featureStoreProvider: FeatureStoreProvider
    private let queue = DispatchQueue(label: "com.heavylightapps.vexillum")
    
    public init(features: [AnyFeature]? = nil, featureStoreProvider: FeatureStoreProvider = UserDefaultsFeatureStore()) {
        self.featureStoreProvider = featureStoreProvider
        if let features = features {
            let _ = try? addFeatures(features)
        }
    }

    // MARK: - Adding features
    @discardableResult
    public func addFeature(_ feature: AnyFeature) throws -> Bool {
        try queue.sync {
            guard !feature.key.isEmpty else { throw FeatureContainerError.featureKeyIsEmpty }
            guard features[feature.key] == nil else { throw FeatureContainerError.featureAlreadyExists(feature.key) }
            
            if let featureAttributes = featureStoreProvider.featureAttributes(forKey: feature.key) {
                feature.state = featureAttributes.state
                (feature as? Feature)?.updateDefaultState(to: featureAttributes.defaultValue)
            }
            features[feature.key] = feature
            
            if let feature = feature as? Feature {
                feature.didChangeStateHandler = { [weak self] updatedFeature in
                    guard let self = self else { return }
                    self.featureStoreProvider.setAttributes(.init(state: updatedFeature.state, defaultValue: feature.defaultState), forKey: updatedFeature.key)
                }
            }
            
            return true
        }
    }
    
    @discardableResult
    public func addFeatures(_ features: [AnyFeature]) throws -> Bool {
        try features.map { try addFeature($0) }.allSatisfy { $0 }
    }
    
    // MARK: - Removing features
    public func removeFeature(_ feature: Feature) {
        queue.sync {
            guard let feature = features[feature.key] else { return }
            features[feature.key] = nil
        }
    }
    
    // MARK: - Retrieving features and enabled values
    public func featureForKey(_ key: FeatureKey) throws -> Feature {
        try queue.sync {
            guard let feature = features[key] as? Feature else { throw FeatureContainerError.noFeatureFound(key) }
            return feature
        }
    }
    
    private func optionalFeatureForKey(_ key: FeatureKey) -> Feature? {
        queue.sync {
            features[key] as? Feature
        }
    }
    
    subscript(dynamicMember member: String) -> Feature? {
        queue.sync {
            try? featureForKey(member)
        }
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
                    self.featureStoreProvider.setAttributes(.init(state: .default, defaultValue: feature.defaultState), forKey: $0.key)
                }
            }
            completion()
        }
    }
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

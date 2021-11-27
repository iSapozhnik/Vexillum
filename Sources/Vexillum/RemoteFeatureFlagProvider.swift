import Foundation

public protocol RemoteFeatureFlagProvider {
    func fetchWithHandler(_ handler: @escaping ([FeatureKey: Bool]) -> Void)
}

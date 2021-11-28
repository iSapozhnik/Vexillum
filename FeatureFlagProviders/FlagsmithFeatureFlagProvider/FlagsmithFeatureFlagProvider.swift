import Vexillum

final class FlagsmithFeatureFlagProvider: RemoteFeatureFlagProvider {
//    private let flagsmith = Flagsmith.shared
//
//    init(withApiKey apiKey: String, configure: () -> Void) {
//        flagsmith.enableAnalytics = true
//        flagsmith.apiKey = apiKey
//    }
//
    func fetchWithHandler(_ handler: @escaping ([FeatureKey: Bool]) -> Void) {

//        var remoteFeatureFlags: [String: Bool] = [:]
//        flagsmith.getFeatureFlags { result in
//            switch result {
//            case .success(let flags):
//                flags.forEach { flag in
//                    remoteFeatureFlags[flag.feature.name] = flag.enabled
//                }
//            case .failure(let error):
//                print(error)
//            }
//            handler(remoteFeatureFlags)
//        }
    }
}

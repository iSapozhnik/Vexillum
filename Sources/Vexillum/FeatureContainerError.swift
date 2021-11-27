import Foundation

enum FeatureContainerError {
    case featureAlreadyExists(String)
    case noFeatureFound(String)
    case featureKeyIsEmpty
}

extension FeatureContainerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .featureAlreadyExists(let key):
            return "A feature with \(key) is already added to the container."
        case .noFeatureFound(let key):
            return "A feature with \(key) could not be found."
        case .featureKeyIsEmpty:
            return "A feature key can not be empty."
        }
    }
}

extension FeatureContainerError: Equatable {
    public static func ==(lhs: FeatureContainerError, rhs: FeatureContainerError) -> Bool {
        switch (lhs, rhs) {
        case (.featureAlreadyExists(let lKey), .featureAlreadyExists(let rKey)):
            return lKey == rKey
        case (.noFeatureFound(let lKey), .noFeatureFound(let rKey)):
            return lKey == rKey
        case (.featureKeyIsEmpty, .featureKeyIsEmpty):
            return true
        default: return false
        }
    }
}

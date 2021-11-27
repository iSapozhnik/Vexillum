import XCTest
@testable import Vexillum

final class FeatureContainerTests: XCTestCase {
    private var container: FeatureContainer!
    
    override func setUp() {
        super.setUp()
        
        container = try! FeatureContainer(featureStoreProvider: InMemoryFeatureStore())
    }
    
    func test_whenPassingThroughConstructor() throws {
        // Arrange
        container = try FeatureContainer(features: [
            Feature(key: .featureA), Feature(key: .featureB)
        ], featureStoreProvider: InMemoryFeatureStore())
        
        // Act
        // Assert
        let retrievedFeatures = [
            try! container.featureForKey(.featureA),
            try! container.featureForKey(.featureB)
        ]
        
        // Assert
        XCTAssertEqual(retrievedFeatures.count, 2)
        XCTAssertEqual(retrievedFeatures[0].key, .featureA)
        XCTAssertEqual(retrievedFeatures[1].key, .featureB)
    }
    
    func test_whenAddingFeatureWithoutKey() throws {
        // Arrange
        let feature = Feature(key: "")
        
        // Act
        // Assert
        assert(try container.addFeature(feature), throws: FeatureContainerError.featureKeyIsEmpty)
    }
    
    func test_whenAddingSameFeature() throws {
        // Arrange
        let feature = Feature(key: .appKey)
        
        // Act
        try! container.addFeature(feature)
        
        // Assert
        assert(try container.addFeature(feature), throws: FeatureContainerError.featureAlreadyExists(feature.key))
    }
    
    func test_whenRemovingFeature() throws {
        // Arrange
        let feature = Feature(key: .appKey)
        
        // Act
        try! container.addFeature(feature)
        container.removeFeature(feature)
        
        // Assert
        XCTAssertTrue(try container.addFeature(feature))
    }
    
    func test_whenRetrievingValyeViaSubscript() throws {
        // Arrange
        let feature = Feature(key: .appKey, defaultState: true)
        
        // Act
        try! container.addFeature(feature)
        
        // Assert
        XCTAssertTrue(container[.appKey])
    }
    
    func test_whenStateChangedAndRetrievingValyeViaSubscript() throws {
        // Arrange
        let feature = Feature(key: .appKey, defaultState: true)
        
        // Act
        try! container.addFeature(feature)
        feature.state = .off
        
        // Assert
        XCTAssertFalse(container[.appKey])
    }
    
    func test_whenStateChangedAndDefaultedRetrievingValyeViaSubscript() throws {
        // Arrange
        let feature = Feature(key: .appKey, defaultState: true)
        
        // Act
        try! container.addFeature(feature)
        feature.state = .off
        feature.state = .default
        
        // Assert
        XCTAssertTrue(container[.appKey])
    }
    
    func test_whenRetrieveingOverridenState() throws {
        // Arrange
        let featureA = Feature(key: .appKey)
        let featureB = Feature(key: .appKey)
        
        // Act
        try! container.addFeature(featureA)
        featureA.state = .on
        container.removeFeature(featureA)
        
        try! container.addFeature(featureB)
        let retrievedFeature = try! container.featureForKey(.appKey)
        
        // Assert
        XCTAssertEqual(retrievedFeature.state, .on)
    }
    
    func test_addingMultipleFeatures_whenSuccess() throws {
        // Arrange
        let featureA = Feature(key: .featureA)
        let featureB = Feature(key: .featureB)
        
        // Act
        let result = try! container.addFeatures([featureA, featureB])
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_addingMultipleFeatures_whenFailure() throws {
        // Arrange
        let featureA = Feature(key: .featureA)
        let featureB = Feature(key: .featureA)
        
        // Act
        // Assert
        assert(try container.addFeatures([featureA, featureB]), throws: FeatureContainerError.featureAlreadyExists(.featureA))
    }
    
    func test_dynamicMemberLookup() throws {
        // Arrange
        let featureA = Feature(key: .featureA)
        
        // Act
        try! container.addFeature(featureA)
        
        // Assert
        XCTAssertEqual(container.featureA?.key, .featureA)
    }
}

import XCTest
@testable import Vexillum

final class FeatureTests: XCTestCase {
    private let someTitle = "Some title"
    private let someDescription = "Some description"
    
    func test_featureWhenDefault() throws {
        let feature = Feature(key: .appKey)
        
        XCTAssertFalse(feature.defaultState)
        XCTAssertFalse(feature.enabled)
        XCTAssertEqual(feature.key, .appKey)
        XCTAssertEqual(feature.title, .appKey)
        XCTAssertTrue(feature.featureDescription.isEmpty)
        XCTAssertTrue(feature.state == .default)
    }
    
    func test_featureInDefaultState() throws {
        let feature = Feature(key: .appKey, title: someTitle, featureDescription: someDescription)
        
        XCTAssertFalse(feature.defaultState)
        XCTAssertFalse(feature.enabled)
        XCTAssertEqual(feature.key, .appKey)
        XCTAssertEqual(feature.title, someTitle)
        XCTAssertEqual(feature.featureDescription, someDescription)
        XCTAssertTrue(feature.state == .default)
    }
    
    func test_featureWhenOverriden() throws {
        let feature = Feature(key: .appKey)
        feature.state = .on
        
        XCTAssertFalse(feature.defaultState)
        XCTAssertTrue(feature.enabled)
        XCTAssertEqual(feature.key, .appKey)
        XCTAssertEqual(feature.title, .appKey)
        XCTAssertTrue(feature.featureDescription.isEmpty)
        XCTAssertTrue(feature.state == .on)
    }
    
    func test_featureWhenDefaultTrue() throws {
        let feature = Feature(key: .appKey, defaultState: true)
        
        XCTAssertTrue(feature.defaultState)
        XCTAssertTrue(feature.enabled)
        XCTAssertEqual(feature.key, .appKey)
        XCTAssertEqual(feature.title, .appKey)
        XCTAssertTrue(feature.featureDescription.isEmpty)
        XCTAssertTrue(feature.state == .default)
    }
    
    func test_featureColorWhenDefaultOn() throws {
        let feature = Feature(key: .appKey, defaultState: true)
        XCTAssertEqual(feature.color, .systemGreen)
    }
    
    func test_featureColorWhenDefaultOff() throws {
        let feature = Feature(key: .appKey, defaultState: false)
        
        XCTAssertEqual(feature.color, .systemGray3)
    }
    
    func test_featureColorWhenDefaultOnAndOverridenOff() throws {
        let feature = Feature(key: .appKey, defaultState: true)
        feature.state = .off
        XCTAssertEqual(feature.color, .systemOrange)
    }
    
    func test_featureColorWhenDefaultOnAndOverridenOn() throws {
        let feature = Feature(key: .appKey, defaultState: true)
        feature.state = .on
        XCTAssertEqual(feature.color, .systemOrange)
    }
    
    func test_featureColorWhenDefaultOffAndOverridenOn() throws {
        let feature = Feature(key: .appKey, defaultState: false)
        feature.state = .on
        XCTAssertEqual(feature.color, .systemOrange)
    }
    
    func test_featureColorWhenDefaultOffAndOverridenOff() throws {
        let feature = Feature(key: .appKey, defaultState: false)
        feature.state = .off
        XCTAssertEqual(feature.color, .systemOrange)
    }
    
    func test_featureDescriptionWhenStateOn() throws {
        let feature = Feature(key: .appKey)
        feature.state = .on
        XCTAssertEqual(feature.state.description, "On")
    }
    
    func test_featureDescriptionWhenStateOff() throws {
        let feature = Feature(key: .appKey)
        feature.state = .off
        XCTAssertEqual(feature.state.description, "Off")
    }
    
    func test_featureDescriptionWhenStateDefault() throws {
        let feature = Feature(key: .appKey)
        feature.state = .default
        XCTAssertEqual(feature.state.description, "Default")
    }
}

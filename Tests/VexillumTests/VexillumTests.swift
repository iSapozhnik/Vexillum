import XCTest
@testable import Vexillum

final class FeatureTests: XCTestCase {
    private let someKey = "app_key"
    private let someTitle = "Some title"
    private let someDescription = "Some description"
    
    func test_featureWhenDefault() throws {
        let feature = Feature(key: someKey)
        
        XCTAssertFalse(feature.defaultState)
        XCTAssertFalse(feature.enabled)
        XCTAssertEqual(feature.key, someKey)
        XCTAssertEqual(feature.title, someKey)
        XCTAssertTrue(feature.description.isEmpty)
        XCTAssertTrue(feature.state == .default)
    }
    
    func test_featureInDefaultState() throws {
        let feature = Feature(key: someKey, title: someTitle, description: someDescription)
        
        XCTAssertFalse(feature.defaultState)
        XCTAssertFalse(feature.enabled)
        XCTAssertEqual(feature.key, someKey)
        XCTAssertEqual(feature.title, someTitle)
        XCTAssertEqual(feature.description, someDescription)
        XCTAssertTrue(feature.state == .default)
    }
    
    func test_featureWhenOverriden() throws {
        let feature = Feature(key: someKey)
        feature.state = .on
        
        XCTAssertFalse(feature.defaultState)
        XCTAssertTrue(feature.enabled)
        XCTAssertEqual(feature.key, someKey)
        XCTAssertEqual(feature.title, someKey)
        XCTAssertTrue(feature.description.isEmpty)
        XCTAssertTrue(feature.state == .on)
    }
    
    func test_featureWhenDefaultTrue() throws {
        let feature = Feature(key: someKey, defaultState: true)
        
        XCTAssertTrue(feature.defaultState)
        XCTAssertTrue(feature.enabled)
        XCTAssertEqual(feature.key, someKey)
        XCTAssertEqual(feature.title, someKey)
        XCTAssertTrue(feature.description.isEmpty)
        XCTAssertTrue(feature.state == .default)
    }
    
    func test_featureColorWhenDefaultOn() throws {
        let feature = Feature(key: someKey, defaultState: true)
        
        XCTAssertEqual(feature.color, "💚")
    }
    
    func test_featureColorWhenDefaultOff() throws {
        let feature = Feature(key: someKey, defaultState: false)
        
        XCTAssertEqual(feature.color, "🖤")
    }
    
    func test_featureColorWhenDefaultOnAndOverridenOff() throws {
        let feature = Feature(key: someKey, defaultState: true)
        feature.state = .off
        XCTAssertEqual(feature.color, "💛")
    }
    
    func test_featureColorWhenDefaultOnAndOverridenOn() throws {
        let feature = Feature(key: someKey, defaultState: true)
        feature.state = .on
        XCTAssertEqual(feature.color, "💛")
    }
    
    func test_featureColorWhenDefaultOffAndOverridenOn() throws {
        let feature = Feature(key: someKey, defaultState: false)
        feature.state = .on
        XCTAssertEqual(feature.color, "💛")
    }
    
    func test_featureColorWhenDefaultOffAndOverridenOff() throws {
        let feature = Feature(key: someKey, defaultState: false)
        feature.state = .off
        XCTAssertEqual(feature.color, "💛")
    }
    
    func test_featureDescriptionWhenStateOn() throws {
        let feature = Feature(key: someKey)
        feature.state = .on
        XCTAssertEqual(feature.state.description, "On")
    }
    
    func test_featureDescriptionWhenStateOff() throws {
        let feature = Feature(key: someKey)
        feature.state = .off
        XCTAssertEqual(feature.state.description, "Off")
    }
    
    func test_featureDescriptionWhenStateDefault() throws {
        let feature = Feature(key: someKey)
        feature.state = .default
        XCTAssertEqual(feature.state.description, "Default")
    }
}

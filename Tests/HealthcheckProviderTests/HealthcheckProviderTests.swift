import XCTest
@testable import HealthcheckProvider
@testable import Vapor
import Testing

class HealthcheckProviderTests: XCTestCase {
    
    override func setUp() {
        Testing.onFail = XCTFail
    }

    func testHealthcheck() {
        var config = try! Config(arguments: ["vapor", "--env=test"])
        try! config.set("healthcheck.url", "healthcheck")
        try! config.addProvider(HealthcheckProvider.Provider.self)
        let drop = try! Droplet(config)
        background {
            try! drop.run()
        }
        
        try! drop
            .testResponse(to: .get, at: "healthcheck")
            .assertStatus(is: .ok)
            .assertJSON("status", equals: "up")
    }

    static var allTests = [
        ("testHealthcheck", testHealthcheck),
    ]
}

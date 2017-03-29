#if os(Linux)

import XCTest
@testable import AppLogicTests

XCTMain([
    // AppLogicTests
    testCase(RouteTests.allTests),
])

#endif

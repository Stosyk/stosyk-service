#if os(Linux)

import XCTest
@testable import AppLogicTests

XCTMain([
    // AppLogicTests
    testCase(RouteTests.allTests),
    testCase(V1PublicCollectionTests.allTests),
    testCase(V1ManageCollectionTests.allTests),
    // Admin
    testCase(TeamControllerTests.allTests),
    testCase(UserControllerTests.allTests),
    testCase(AdminControllerTests.allTests)
])

#endif

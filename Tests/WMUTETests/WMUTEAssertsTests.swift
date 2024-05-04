import XCTest
@testable import WMUTE

final class WMUTEAssertsTests: XCTestCase {

	enum SomeError: Error {
		case errorA
	}

	func testGivenAsyncThrowingMethodWhenThrowsErrorThenTestShouldPass() async {
		await XCTAssertThrowsAsyncError(
			{
				try await Task {
					throw SomeError.errorA
				}.value
			}, 
			errorHandler: { error in
				XCTAssertEqual(error as? SomeError, SomeError.errorA)
			}
		)
	}

	func testGivenAsyncThrowingMethodWhenThrowsEquatableErrorThenTestShouldPass() async {
		await XCTAssertThrowsAsyncErrorEqual(
			{
				try await Task {
					throw SomeError.errorA
				}.value
			},
			error: SomeError.errorA
		)
	}
}

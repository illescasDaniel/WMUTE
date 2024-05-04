import XCTest

public func XCTAssertThrowsAsyncError<T>(
	_ expression: () async throws -> T,
	message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line,
	errorHandler: (_ error: any Error) -> Void = { _ in }
) async {
	do {
		_ = try await expression()
		XCTFail(message(), file: file, line: line)
	} catch {
		errorHandler(error)
	}
}

public func XCTAssertThrowsAsyncErrorEqual<T, E: Error & Equatable>(
	_ expression: () async throws -> T,
	error: E,
	message: @autoclosure () -> String = "",
	file: StaticString = #filePath,
	line: UInt = #line
) async {
	await XCTAssertThrowsAsyncError(
		expression,
		message: message(),
		file: file,
		line: line,
		errorHandler: { e in
			XCTAssertEqual(e as? E, error)
		}
	)
}

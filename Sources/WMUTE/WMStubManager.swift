import XCTest

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public final class WMStubManager {

	private let baseURL: URL
	private let mockURL: URL
	private let urlSession: URLSession

	public init(baseURL: URL, urlSession: URLSession) {
		self.baseURL = baseURL
		self.mockURL = baseURL.appending(path: "__admin/mappings")
		self.urlSession = urlSession
	}

	public func addStub(_ stubData: Data) async throws {
		var request = URLRequest(url: mockURL)
		request.httpMethod = "POST"
		request.httpBody = stubData
		_ = try await urlSession.data(for: request)
	}

	public func resetStubs() async throws {
		var request = URLRequest(url: mockURL.appending(path: "reset"))
		request.httpMethod = "POST"
		_ = try await urlSession.data(for: request)
	}

	public func runWithStub<T>(_ stubData: Data, block: () async throws -> T) async throws -> T {
		do {
			try await addStub(stubData)
			let result = try await block()
			try? await resetStubs()
			return result
		} catch {
			try? await resetStubs()
			throw error
		}
	}
}

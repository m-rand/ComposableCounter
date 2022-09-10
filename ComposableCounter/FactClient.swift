import Combine
import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

struct FactClient {
    var fetchAsync: @Sendable (Int) async throws -> String
    var fetchCombine: (Int) -> Effect<String, Error>
}

// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
// Typically this live implementation of the dependency would live in its own module so that the
// main feature doesn't need to compile it.
extension FactClient {
    static let live = Self(
        fetchAsync: { number in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let (data, _) = try await
            URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
            return String(decoding: data, as: UTF8.self)
        },
        fetchCombine: { number in
            URLSession.shared.dataTaskPublisher(
                for: URL(string: "http://numbersapi.com/\(number)/trivia")!
            )
            .map { data, _ in String(decoding: data, as: UTF8.self) }
            .catch { _ in
                // Sometimes numbersapi.com can be flakey, so if it ever fails we will just
                // default to a mock response.
                Just("\(number) is a good number Brent")
                    .delay(for: 1, scheduler: DispatchQueue.main)
            }
            .setFailureType(to: Error.self)
            .eraseToEffect()
        }
    )
}

#if DEBUG
extension FactClient {
    // This is the "unimplemented" fact dependency that is useful to plug into tests that you want
    // to prove do not need the dependency.
    static let unimplemented = Self(
        fetchAsync: XCTUnimplemented("\(Self.self).fetchAsync"),
        fetchCombine: XCTUnimplemented("\(Self.self).fetchCombine")
    )
}
#endif

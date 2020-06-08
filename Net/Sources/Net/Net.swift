import Foundation

import Proto

/// A result of a network service's method call.
public typealias ServiceResult<T> = Result<T, NetworkError>

/// Represents a networking error that may happen during network service's method call.
public final class NetworkError: Error {
    /// Code of the error.
    public let code: Code
    /// Possible unlocalized error message.
    public let message: String?

    /// - Parameters:
    ///   - code: Error code.
    ///   - message: An optional error message.
    public init(code: Code, message: String? = nil) {
        self.code = code
        self.message = message
    }
}

// MARK: Extensions

public extension NetworkError {
    /// Represents all posible error codes.
    ///
    /// For more details on errors from 1 to 15 see [gRPC](
    /// https://github.com/grpc/grpc/blob/master/doc/statuscodes.md) specification.
    enum Code: Int {
        /// The operation was cancelled.
        case cancelled = 1

        /// An unknown error.
        case unknown = 2

        /// An invalid request argument was specified.
        case invalidArgument = 3

        /// The operation couldn't be completed within an allowed time interval.
        case deadlineExceeded = 4

        /// Requested entity was not found.
        case notFound = 5

        /// The entity you're trying to create already exists.
        case alreadyExists = 6

        /// You don't have enough permissions for the requested operation.
        case permissionDenied = 7

        /// Authentication for the request is required.
        case unauthenticated = 16

        /// Server doesn't have enough resources to process your request.
        case resourceExhausted = 8

        /// Required conditions are not met for the requested operation.
        case failedPrecondition = 9

        /// Requested operarion was unintentionally aborted.
        case aborted = 10

        /// The operation was attempted past the valid range.
        case outOfRange = 11

        /// Operation is not implemented or not supported.
        case unimplemented = 12

        /// An unexpected server error occured.
        case internalError = 13

        /// The service is unavailable.
        case unavailable = 14

        /// Unrecoverable data loss or corruption.
        case dataLoss = 15
    }
}

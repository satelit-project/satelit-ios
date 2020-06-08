import Foundation

import Net

/// Base class for every mock network service.
public class MockService {
    /// Response delay in seconds.
    private var delay: TimeInterval = 2
    
    /// A queue of errors to respond with when simulating responses.
    private var errorQueue = [NetworkError]()
    
    /// A sync queue to schedule service operations.
    private let queue = DispatchQueue(label: "moe.shitty.net.mockservice")
    
    /// Sets a delay for every emulated response.
    /// - Parameter delay: response delay in seconds.
    func setResponseDelay(delay: TimeInterval) {
        queue.async { [weak self] in
            self?.delay = delay
        }
    }
    
    /// Queue an error to respond with on a future emulated response.
    /// - Parameter error: an error to respond with.
    func setNextRequestError(_ error: NetworkError) {
        queue.async { [weak self] in
            self?.errorQueue.append(error)
        }
    }
    
    /// Emulates a service response with a provided value.
    ///
    /// If there's an error in a response error queue then the response will contain the error instead of passed data.
    /// - Parameters:
    ///   - data: response data for a successful response.
    ///   - completion: a closure to call when response is ready.
    func emulateResponse<T>(with data: T, completion: @escaping (ServiceResult<T>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let error = self.errorQueue.popLast()
            self.queue.asyncAfter(deadline: .now() + .seconds(Int(self.delay))) {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(data))
                }
            }
        }
    }
}

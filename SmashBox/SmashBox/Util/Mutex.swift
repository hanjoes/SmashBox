import Foundation


/// There is a difference between defining our Mutex as a class
/// and defining our mutex as a struct. Class is easier for being
/// shared, since it's passed by reference, even if it's a field
/// in another thread.
public class Mutex {
    
    public var mutex = pthread_mutex_t()
    
    public init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    /// Execute the closure exclusively using mutex.
    ///
    /// - Parameter closure: closure to execute
    /// - Returns: result returned by closure
    /// - Throws: possibly the exception thrown by the closure
    @discardableResult
    public func synchronized<R>(closure: () throws -> R) rethrows -> R {
        pthread_mutex_lock(&mutex)
        defer {
            pthread_mutex_unlock(&mutex)
        }
        return try closure()
    }
}

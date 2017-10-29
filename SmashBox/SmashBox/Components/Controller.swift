import GameplayKit

typealias ControllerComponent = Controller & GKComponent

/// This protocol should be conformed to by a `GKComponent`
/// subclass for control-related logic.
protocol Controller {
    /// Call this method after the conformant component
    /// is added to the entity to register control logic
    /// to the enclosing entity.
    func possess()
}

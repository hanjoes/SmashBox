import GameplayKit

class PlayerEntity: GameEntity {
    var sceneNodeComponent: SCNNodeComponent! {
        return component(ofType: SCNNodeComponent.self)!
    }
}

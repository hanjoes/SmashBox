import GameplayKit

class PlayerEntity: GameEntity {
    var sceneNodeComponent: SCNNodeComponent! {
        return component(ofType: SCNNodeComponent.self)!
    }
    
    var networkComponent: NetworkControllerComponent? {
        return component(ofType: NetworkControllerComponent.self)
    }
    
    var userGestureComponent: UserGestureControllerComponent? {
        return component(ofType: UserGestureControllerComponent.self)
    }
    
    func publish(force vector: SCNVector3) throws {
        guard let networkComponent = networkComponent else {
            return
        }

        let cc = networkComponent.communicationCenter
        try cc.publish(force: vector)
    }
}

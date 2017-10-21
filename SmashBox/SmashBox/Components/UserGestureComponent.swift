import GameplayKit
import SceneKit

class UserGestureComponent: UserInteractionComponent {

    /// Initialize gestures.
    ///
    /// - Note: Ideally, we should use `didAddToEntity` to do this
    /// initialization, but the callback is only available after
    /// __iOS 10.0__.
    func initializeGestures() {
        guard let entity = entity as? GameEntity else {
            return
        }
        
        let sceneView = entity.sceneView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
}

extension UserInteractionComponent {

    @objc
    func handleTap(_ gestureRecognized: UIGestureRecognizer) {
        guard let gameEntity = entity as? GameEntity else {
            return
        }

        let sceneView = gameEntity.sceneView
        let player = scnNodeComponent.scnNode
        
        switch gestureRecognized.state {
        case .ended:
            let location = gestureRecognized.location(in: sceneView)
            let hits = sceneView.hitTest(location, options: [SCNHitTestOption.firstFoundOnly: ()])
            guard let hit = hits.first, hit.node.name == Constants.BattleAreaFloorName else {
                return
            }
            
            let hitCoord = hit.localCoordinates
            let playerCoord = player.presentation.position
            let translation = (hitCoord - playerCoord) * 0.5
            
            let translationHorizontal = SCNVector3(x: translation.x, y: 0, z: translation.z)
            player.physicsBody?.applyForce(translationHorizontal, asImpulse: true)
        default: break
        }
    }
    
}



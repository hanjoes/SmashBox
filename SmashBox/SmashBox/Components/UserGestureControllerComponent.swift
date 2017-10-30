import GameplayKit
import SceneKit

class UserGestureControllerComponent: GKComponent, Controller {
    func possess() {
        let sceneView = playerEntity.sceneView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
}

extension UserGestureControllerComponent {
    
    var playerEntity: PlayerEntity {
        return entity as! PlayerEntity
    }
    
    var scnNodeComponent: SCNNodeComponent {
        return playerEntity.sceneNodeComponent
    }

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
            
            do {
                try playerEntity.publish(force: translationHorizontal)
            } catch  {
                print("\(#function) publishing failed")
            }
        default: break
        }
    }
    
}



import Foundation
import GameplayKit
import MultipeerConnectivity

class NetworkControllerComponent: GKComponent, Controller {
    
    var communicationCenter: CommunicationCenter
    
    var playerEntity: PlayerEntity {
        return entity as! PlayerEntity
    }
    
    var scnNodeComponent: SCNNodeComponent {
        return playerEntity.sceneNodeComponent
    }
    
    init(communicationCenter: CommunicationCenter) {
        self.communicationCenter = communicationCenter
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func possess() {
    }
}

extension NetworkControllerComponent: CommunicationEventDelegate {
    
    func handle(peerMessage msg: PeerMessage) {
        switch msg.messageType {
        case PeerMessageType.Force:
            scnNodeComponent.scnNode.physicsBody?.applyForce(msg.force, asImpulse: true)
        case PeerMessageType.Position:
            scnNodeComponent.scnNode.position = msg.position
        default: break
        }
    }
}

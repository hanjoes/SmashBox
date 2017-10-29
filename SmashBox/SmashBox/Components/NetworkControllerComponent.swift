import Foundation
import GameplayKit

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
        switch msg.message {
        case .force(let v):
            scnNodeComponent.scnNode.physicsBody?.applyForce(v, asImpulse: true)
        }
    }
}

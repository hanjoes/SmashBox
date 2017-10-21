import GameplayKit

class SCNNodeComponent: GKComponent {
    var scnNode: SCNNode
    
    init(withNode node: SCNNode) {
        self.scnNode = node
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

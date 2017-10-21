import GameplayKit

class GameEntity: GKEntity {
    unowned var sceneView: SCNView
    
    init(components: [GKComponent], sceneView: SCNView) {
        self.sceneView = sceneView
        super.init()
        
        components.forEach { addComponent($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

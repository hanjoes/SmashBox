import GameplayKit


/// The component that accepts user interaction.
/// The entity owns this component must have a
/// `SCNNode` component.
class UserInteractionComponent: GKComponent {
    
    var scnNodeComponent: SCNNodeComponent
    
    init(scnNodeComponent: SCNNodeComponent) {
        self.scnNodeComponent = scnNodeComponent
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


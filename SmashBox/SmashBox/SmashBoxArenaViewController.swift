import UIKit
import QuartzCore
import SceneKit


class SmashBoxArenaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeScene()
        initializeGestures()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}

// MARK: - Helper Methods

private extension SmashBoxArenaViewController {
    
    var sceneView: SCNView! {
        return self.view as! SCNView
    }
    
    var arenaFloor: SCNNode! {
        return scene.rootNode.childNode(withName: Constants.BattleAreaFloorName, recursively: true)
    }
    
    var player: SCNNode! {
        return scene.rootNode.childNode(withName: Constants.PlayerName, recursively: true)
    }
    
    var scene: SCNScene! {
        return sceneView.scene
    }
    
    func initializeScene() {
        sceneView.scene = SCNScene(named: Constants.BattleAreaSceneName)
        sceneView.backgroundColor = .purple
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
    }
    
    func initializeGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Gesture Handlers

private extension SmashBoxArenaViewController {
    @objc
    func handleTap(_ gestureRecognized: UIGestureRecognizer) {
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

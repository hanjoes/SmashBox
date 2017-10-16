import UIKit
import QuartzCore
import SceneKit


class SmashBoxArenaViewController: UIViewController {
    
    var player: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeScene()
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
    
    func initializeScene() {
        let scene = SCNScene(named: Constants.BattleAreaSceneName)!
        let view = self.view as! SCNView
        view.scene = scene
        view.backgroundColor = .purple
        
        view.allowsCameraControl = true
    }
    
}

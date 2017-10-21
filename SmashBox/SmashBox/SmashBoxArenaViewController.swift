import UIKit
import QuartzCore
import SceneKit


class SmashBoxArenaViewController: UIViewController {
    
    var boxEntity: BoxEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeScene()
        spawnPlayer()
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
    
    var spawnPoints: [SCNNode] {
        let children = scene.rootNode.childNodes
        var spawnPoints = [SCNNode]()
        for child in children {
            if child.name! == Constants.SpawnPointName {
                spawnPoints.append(child)
            }
        }
        return spawnPoints
    }
    
    func initializeScene() {
        sceneView.scene = SCNScene(named: Constants.BattleAreaSceneName)
        sceneView.backgroundColor = .purple
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
    }
    
    func spawnPlayer() {
        let numSpawnPoints = spawnPoints.count
        let randIndex = Int(arc4random() % UInt32(numSpawnPoints))
        let spawnPointChosen = spawnPoints[randIndex]
        
        player.position = spawnPointChosen.position
        let scnNodeComponent = SCNNodeComponent(withNode: player)
        let userGestureComponent = UserGestureComponent(scnNodeComponent: scnNodeComponent)
        boxEntity = BoxEntity(components: [scnNodeComponent, userGestureComponent], sceneView: sceneView)
        userGestureComponent.initializeGestures()
    }
}


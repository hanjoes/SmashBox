import UIKit
import QuartzCore
import SceneKit


class SmashBoxArenaViewController: UIViewController {
    
    var communicationCenter: CommunicationCenter!
    
    var entityManager = EntityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communicationCenter = CommunicationCenter(entityManager: entityManager)
        communicationCenter.start()
        
        initializeScene()
        spawnPlayer()
        takeControl(ofPlayer: 0)
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
    
    var scene: SCNScene! {
        return sceneView.scene
    }
    
    var players: [PlayerEntity] {
        return entityManager.players
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
        scene.background.contents = UIColor.clear
        sceneView.backgroundColor = .purple
        sceneView.allowsCameraControl = true
        sceneView.isPlaying = true
    }
    
    func spawnPlayer() {
        let numSpawnPoints = spawnPoints.count
        let randIndex = Int(arc4random() % UInt32(numSpawnPoints))
        let spawnPointChosen = spawnPoints[randIndex]
        
        let box = SCNBox(width: 3, height: 3, length: 3, chamferRadius: 0.3)
        let player = SCNNode(geometry: box)
        player.name = "\(Constants.PlayerName)_\(players.count + 1)"
        player.position = spawnPointChosen.position
        player.physicsBody = SCNPhysicsBody.dynamic()
        player.physicsBody?.isAffectedByGravity = true
        
        let playerLight = SCNNode()
        playerLight.light = SCNLight()
        playerLight.light?.type = .spot
        playerLight.position = SCNVector3(x: 0, y: 10, z: 0)
        playerLight.eulerAngles = SCNVector3(x: -Float(Double.pi / 2), y: 0, z: 0)
        player.addChildNode(playerLight)

        scene.rootNode.addChildNode(player)
        
        let scnNodeComponent = SCNNodeComponent(withNode: player)
        let playerEntity = PlayerEntity(components: [scnNodeComponent], sceneView: sceneView)
        entityManager.players.append(playerEntity)
    }
    
    func takeControl(ofPlayer index: Int) {
        guard players.count >= index else {
            return
        }
        
        let player = players[index]
        let userGestureComponent = UserGestureControllerComponent()
        player.addComponent(userGestureComponent)
        userGestureComponent.possess()
        
        let networkComponent = NetworkControllerComponent(communicationCenter: communicationCenter)
        player.addComponent(networkComponent)
    }
}


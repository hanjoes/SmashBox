import MultipeerConnectivity
import SceneKit


protocol CommunicationEventDelegate {
    func handle(peerMessage msg: PeerMessage)
}


class CommunicationCenter: NSObject {
    
    typealias CommunicationMetadata = (MCSession, CommunicationEventDelegate?)
    
    let myPeerID = MCPeerID(displayName: "\(UIDevice.current.name)_smashbox")
    
    let browser: MCNearbyServiceBrowser
    
    let advertiser: MCNearbyServiceAdvertiser
    
    let jsonEncoder = JSONEncoder()
    
    let jsonDecoder = JSONDecoder()
    
    let entityManager: EntityManager
    
    var peers = [MCPeerID:CommunicationMetadata]()
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: Constants.ServiceName)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: Constants.ServiceName)
        super.init()
        browser.delegate = self
        advertiser.delegate = self
    }
    
    func start() {
        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
    }
    
    func stop() {
        browser.stopBrowsingForPeers()
        advertiser.stopAdvertisingPeer()
    }
    
    func publish(position vector: SCNVector3) throws {
        var message = PeerMessage()
        message.messageType = PeerMessageType.Position
        message.position = vector
        let syncMessage = try jsonEncoder.encode(message)
        
        try peers.forEach {
            try $0.value.0.send(syncMessage, toPeers: [$0.key], with: .reliable)
        }
    }
    
    func publish(force vector: SCNVector3) throws {
        var message = PeerMessage()
        message.messageType = PeerMessageType.Force
        message.force = vector
        let moveMessage = try jsonEncoder.encode(message)
        
        try peers.forEach {
            try $0.value.0.send(moveMessage, toPeers: [$0.key], with: .reliable)
        }
    }
    
    deinit {
        stop()
    }
    
}

extension CommunicationCenter: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard peers[peerID] == nil else {
            return
        }
        // Having weird disconnected issue when we send out AND accept invitation for the same peerID.
        // This check is here so we can only send out OR accept invitation, not both.
        guard myPeerID.displayName.hash > peerID.displayName.hash else {
            return
        }
        
        let newSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        newSession.delegate = self
        browser.invitePeer(peerID, to: newSession, withContext: nil, timeout: Constants.InviteTimeout)
        peers[peerID] = (newSession, nil)
    }
}

extension CommunicationCenter: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let newSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        newSession.delegate = self
        invitationHandler(true, newSession)
        peers[peerID] = (newSession, nil)
        // adding this seems essential for successful connections, not sure why..
        advertiser.stopAdvertisingPeer()
    }
}

extension CommunicationCenter: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("peer: \(peerID) connected")
            if let unpossessed = entityManager.nextUnpossessedEntity {
                let nc = NetworkControllerComponent(communicationCenter: self)
                unpossessed.addComponent(nc)
                peers[peerID]!.1 = nc
                
                // sync local position to remote
                let user = entityManager.userEntity!
                let scnNodeComp = user.sceneNodeComponent
                let scnNode = scnNodeComp!.scnNode
                try! publish(position: scnNode.presentation.position)
            }
            start()
        case .connecting:
            print("peer: \(peerID) connecting")
            stop()
        case .notConnected:
            print("peer: \(peerID) disconnected")
            peers.removeValue(forKey: peerID)
            stop()
            start()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let metadata = peers[peerID] else {
            return
        }

        guard let peerMessage = try? jsonDecoder.decode(PeerMessage.self, from: data) else {
            return
        }

        metadata.1?.handle(peerMessage: peerMessage)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    
}

import MultipeerConnectivity

class CommunicationCenter: NSObject {
    
    let myPeerID = MCPeerID(displayName: "\(UIDevice.current.name)_smashbox")
    
    let browser: MCNearbyServiceBrowser
    
    let advertiser: MCNearbyServiceAdvertiser
    
    var peers = [String:MCSession]()
    
    override init() {
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
    
    deinit {
        browser.stopBrowsingForPeers()
        advertiser.stopAdvertisingPeer()
    }
    
}

extension CommunicationCenter: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        // Having weird disconnected issue when we send out AND accept invitation for the same peerID.
        // This check is here so we can only send out OR accept invitation, not both.
        guard myPeerID.displayName.hash > peerID.displayName.hash else {
            return
        }
        
        let newSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        newSession.delegate = self
        browser.invitePeer(peerID, to: newSession, withContext: nil, timeout: Constants.InviteTimeout)
        peers[peerID.displayName] = newSession
    }
}

extension CommunicationCenter: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            let newSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
            newSession.delegate = self
            invitationHandler(true, newSession)
            peers[peerID.displayName] = newSession
    }
}

extension CommunicationCenter: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("peer: \(peerID) connected")
        case .connecting:
            print("peer: \(peerID) connecting")
        case .notConnected:
            print("peer: \(peerID) disconnected")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    
}

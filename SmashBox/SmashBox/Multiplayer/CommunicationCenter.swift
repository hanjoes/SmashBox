import MultipeerConnectivity

class CommunicationCenter: NSObject {
    
    let mutex = Mutex()
    
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
        print("searching with peerId: \(myPeerID)")
        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
    }
    
    deinit {
        print("deiniting")
        browser.stopBrowsingForPeers()
        advertiser.stopAdvertisingPeer()
    }
    
}

extension CommunicationCenter: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("peer \(peerID) disconnected")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("cannot start browsing because of error: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        mutex.synchronized {
            print("found peer: \(peerID)")
            guard peers[peerID.displayName] == nil else {
                return
            }
            
            print("inviting peer: \(peerID)")
            let newSession = MCSession(peer: myPeerID)
            newSession.delegate = self
            browser.invitePeer(peerID, to: newSession, withContext: nil, timeout: Constants.InviteTimeout)
            peers[peerID.displayName] = newSession
            print(peers)
        }
    }
}

extension CommunicationCenter: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("cannot start advertizing peer because of error: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        mutex.synchronized {
            print("received invitation from peer: \(peerID)")
            guard peers[peerID.displayName] == nil else {
                invitationHandler(false, nil)
                return
            }
            
            let newSession = MCSession(peer: myPeerID)
            newSession.delegate = self
            invitationHandler(true, newSession)
            peers[peerID.displayName] = newSession
            print("\(myPeerID) accepted invitation")
            print(peers)
        }
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

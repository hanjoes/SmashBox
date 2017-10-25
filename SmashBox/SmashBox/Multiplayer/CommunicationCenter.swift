import MultipeerConnectivity

class CommunicationCenter: NSObject {
    
    let peerId = MCPeerID(displayName: "\(UIDevice.current.name)_smashbox")
    
    let browser: MCNearbyServiceBrowser
    
    let advertiser: MCNearbyServiceAdvertiser
    
    override init() {
        browser = MCNearbyServiceBrowser(peer: peerId, serviceType: Constants.ServiceName)
        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: Constants.ServiceName)
        super.init()
        browser.delegate = self
        advertiser.delegate = self
    }
    
    func start() {
        print("searching with peerId: \(peerId)")
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
        print("found peer: \(peerID)")
    }
}

extension CommunicationCenter: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("cannot start advertizing peer because of error: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("receive invitation from peer: \(peerID)")
    }
}

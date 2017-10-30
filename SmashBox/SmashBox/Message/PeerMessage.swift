import SceneKit
import GameplayKit

/// MessagesType.
struct PeerMessageType {
    /// the force applied to a peer, represented
    /// by forces along x, y, and z axis.
    static let Force = 0
    /// the position of the peer, used for
    /// synchronization.
    static let Position = 1
}

/// Message passed around peers.
/// Check `PeerMessage.Message` for different types of
/// messages.
struct PeerMessage: Codable {
    var messageType = PeerMessageType.Force
    var force: SCNVector3 = SCNVector3Zero
    var position: SCNVector3 = SCNVector3Zero
}

// MARK: - SCNVector3 + Codable
extension SCNVector3: Codable {
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        x = try values.decode(Float.self, forKey: .x)
        y = try values.decode(Float.self, forKey: .y)
        z = try values.decode(Float.self, forKey: .z)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(self.x, forKey: .x)
        try values.encode(self.y, forKey: .y)
        try values.encode(self.z, forKey: .z)
    }
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
    }
}

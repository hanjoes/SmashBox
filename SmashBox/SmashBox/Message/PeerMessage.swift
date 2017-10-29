import SceneKit
import GameplayKit

/// Message passed around peers.
/// Check `PeerMessage.Message` for different types of
/// messages.
struct PeerMessage: Codable {
    
    /// Messages.
    ///
    /// - force: the force applied to a peer, represented
    /// by forces along x, y, and z axis.
    enum Message {

        case force(SCNVector3)
    }
    
    var message: Message
}

// MARK: - PeerMessage + Codable
extension PeerMessage.Message: Codable {
    
    init(from decoder: Decoder) throws {
        let vector = try! SCNVector3(from: decoder)
        self = .force(vector)
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .force(let v):
            try v.encode(to: encoder)
        }
    }
    
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

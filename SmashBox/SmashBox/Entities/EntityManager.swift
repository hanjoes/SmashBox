import GameplayKit

class EntityManager {
    var players = [PlayerEntity]()
    
    var nextUnpossessedEntity: PlayerEntity? {
        for player in players {
            if player.networkComponent == nil {
                return player
            }
        }
        
        return nil
    }
}

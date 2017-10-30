import GameplayKit

class EntityManager {
    var players = [PlayerEntity]()
    
    var userEntity: PlayerEntity? {
        for player in players {
            if player.userGestureComponent != nil {
                return player
            }
        }
        
        return nil
    }
    
    var nextUnpossessedEntity: PlayerEntity? {
        for player in players {
            if player.networkComponent == nil {
                return player
            }
        }
        
        return nil
    }
}

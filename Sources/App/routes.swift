import Vapor
import JWT
import CCryptoOpenSSL

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let userController = UserController()
    router.get("user", use: userController.getUser)
    router.get("user", "all", use: userController.getAllUsers)
    router.get("user", "search", use: userController.findUsersWithName)
    router.post(CreateUser.self, at: "user", use: userController.createUser)
    
    //GET       hero
    //POST      hero/create
    
    //GET       battle
    //GET       battle/all
    //GET       battle/{battleId}
    //POST      battle/create
    //GET       battle/{battleId}/turn
    //POST      battle/{battleId}/turn/create
    //GET       battle/{battleId}/turn/{turnId}/action
    //POST      battle/{battleId}/turn/{turnId}/action
    //PUT       battle/{battleId}/attackerTeamInit
    //PUT       battle/{battleId}/defenderTeamInit
    
    //GET       challenge
    //GET       challenge/find
    //POST      challenge/initiate/{opponentId}
    //PUT       challenge/accept/{challengeId}
    //PUT       challenge/decline/{challengeId}
}

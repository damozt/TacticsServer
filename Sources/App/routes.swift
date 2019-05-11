import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let userController = UserController()
    router.get("user", use: userController.getUser)
    router.get("user", "all", use: userController.getAllUsers)
    router.get("user", "search", use: userController.findUsersWithName)
    router.post(CreateUser.self, at: "user", use: userController.createUser)
    
    //GET       hero
    //POST      hero/create
    
    let battleController = BattleController()
    router.get("battle", Int.parameter, use: battleController.getBattle)
    router.get("battle", "all", use: battleController.getAllBattles)
    router.post(CreateBattle.self, at: "battle", use: battleController.createBattle)
    //PUT       battle/{battleId}/attackerTeamInit
    //PUT       battle/{battleId}/defenderTeamInit
    
    let turnController = TurnController()
    router.get("turn", Int.parameter, use: turnController.getTurn)
    router.get("turn", "battleId", Int.parameter, use: turnController.getTurnsForBattle)
    router.post(CreateBattleTurn.self, at: "turn", use: turnController.createTurn)
    
    let actionController = ActionController()
//    router.get("action", "turnId", Int.parameter, use: actionController.getAction)
    router.post(CreateBattleAction.self, at: "action", use: actionController.createAction)
    
    //GET       challenge
    //GET       challenge/find
    //POST      challenge/initiate/{opponentId}
    //PUT       challenge/accept/{challengeId}
    //PUT       challenge/decline/{challengeId}
}

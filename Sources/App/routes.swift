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
    router.put(TeamInit.self, at: "battle", Int.parameter, "attackerInit", use: battleController.updateAttackerInit)
    router.put(TeamInit.self, at: "battle", Int.parameter, "defenderInit", use: battleController.updateDefenderInit)
    
    let battleTurnController = BattleTurnController()
    router.get("turn", "battleId", Int.parameter, use: battleTurnController.getTurnsForBattle)
    router.post(CreateBattleTurn.self, at: "turn", use: battleTurnController.createTurn)
    
    let battleActionController = BattleActionController()
    router.get("action", "battleId", Int.parameter, use: battleActionController.getActionsForBattle)
    router.post(CreateBattleAction.self, at: "action", use: battleActionController.createAction)
    
    //GET       challenge
    //GET       challenge/find
    //POST      challenge/initiate/{opponentId}
    //PUT       challenge/accept/{challengeId}
    //PUT       challenge/decline/{challengeId}
}

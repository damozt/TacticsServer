import Vapor

public func routes(_ router: Router) throws {
    
//    let userController = UserController()
//    router.get("user", use: userController.getUser)
//    router.get("user", "all", use: userController.getAllUsers)
//    router.get("user", "search", use: userController.findUsersWithName)
//    router.post(CreateUser.self, at: "user", use: userController.createUser)
//
//    let heroController = HeroController()
//    router.get("hero", Int.parameter, use: heroController.getHero)
//    router.get("hero", "user", Int.parameter, use: heroController.getUserHeroes)
//    router.post(CreateHero.self, at: "hero", use: heroController.createHero)
    
    let battleController = BattleController()
    router.get("battle", Int.parameter, use: battleController.getBattle)
//    router.get("battle", use: battleController.getUserBattles)
//    router.post(CreateBattle.self, at: "battle", use: battleController.createBattle)
//    router.put(TeamInit.self, at: "battle", Int.parameter, "attackerInit", use: battleController.updateAttackerInit)
//    router.put(TeamInit.self, at: "battle", Int.parameter, "defenderInit", use: battleController.updateDefenderInit)
    
//    let battleTurnController = BattleTurnController()
//    router.get("turn", "battle", Int.parameter, use: battleTurnController.getTurnsForBattle)
//    router.post(CreateBattleTurn.self, at: "turn", use: battleTurnController.createTurn)
//
//    let battleActionController = BattleActionController()
//    router.get("action", "battle", Int.parameter, use: battleActionController.getActionsForBattle)
//    router.post(CreateBattleAction.self, at: "action", use: battleActionController.createAction)
    
    //GET       challenge
    //GET       challenge/find
    //POST      challenge/initiate/{opponentId}
    //PUT       challenge/accept/{challengeId}
    //PUT       challenge/decline/{challengeId}
}

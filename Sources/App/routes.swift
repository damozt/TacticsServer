import Vapor

public func routes(_ router: Router) throws {
    
    let userController = UserController()
    router.get(userController.rootPathString, use: userController.getUser)
    router.get(userController.rootPathString, "all", use: userController.getAllUsers)
    router.get(userController.rootPathString, "search", use: userController.findUsersWithName)
    router.post(CreateUser.self, at: userController.rootPathString, use: userController.createUser)
    
    let heroController = HeroController()
    router.get(heroController.rootPathString, Int.parameter, use: heroController.getHero)
    router.get(heroController.rootPathString, use: heroController.getUserHeroes)
    router.post(CreateHero.self, at: userController.rootPathString, use: heroController.createHero)
    //update fcmId
    
    let heroCustomizationsController = HeroCustomizationsController()
    router.get(heroCustomizationsController.rootPathString, Int.parameter, use: heroCustomizationsController.getHeroCustomizations)
    router.put(UpdateHeroCustomization.self, at: heroCustomizationsController.rootPathString, use: heroCustomizationsController.updateHeroCustomization)
    
    let battleController = BattleController()
    router.get(battleController.rootPathString, Int.parameter, use: battleController.getBattle)
    router.get(battleController.rootPathString, use: battleController.getUserBattles)
    router.post(CreateBattle.self, at: battleController.rootPathString, use: battleController.createBattle)
    
    let battleInitController = BattleInitController()
    router.post(CreateBattleInit.self, at: battleInitController.rootPathString, use: battleInitController.createBattleInit)
    
    let battleTurnController = BattleTurnController()
    router.get(battleTurnController.rootPathString, "battle", Int.parameter, use: battleTurnController.getTurnsForBattle)
    router.post(CreateBattleTurn.self, at: battleTurnController.rootPathString, use: battleTurnController.createTurn)
    
    let battleActionController = BattleActionController()
    router.get(battleActionController.rootPathString, "battle", Int.parameter, use: battleActionController.getActionsForBattle)
    router.post(CreateBattleAction.self, at: battleActionController.rootPathString, use: battleActionController.createAction)
    
    //GET       challenge
    //GET       challenge/find
    //POST      challenge/initiate/{opponentId}
    //PUT       challenge/accept/{challengeId}
    //PUT       challenge/decline/{challengeId}
}

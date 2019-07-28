import Vapor

public func routes(_ router: Router) throws {
    
    let userController = UserController()
    router.get(userController.rootPathString, use: userController.getUser)
    router.get(userController.rootPathString, "all", use: userController.getAllUsers)
    router.get(userController.rootPathString, "search", use: userController.findUsersWithName)
    router.post(CreateUser.self, at: userController.rootPathString, use: userController.createUser)
    //update fcmId
    
    let heroController = HeroController()
    router.get(heroController.rootPathString, Int.parameter, use: heroController.getHero)
    router.get(heroController.rootPathString, use: heroController.getUserHeroes)
    router.post(CreateHero.self, at: heroController.rootPathString, use: heroController.createHero)
    
    let heroCustomizationController = HeroCustomizationController()
    router.get(heroCustomizationController.rootPathString, Int.parameter, use: heroCustomizationController.getHeroCustomizations)
    router.post(heroCustomizationController.rootPathString, Int.parameter, use: heroCustomizationController.createHeroCustomization)
    router.put(UpdateHeroCustomization.self, at: heroCustomizationController.rootPathString, use: heroCustomizationController.updateHeroCustomization)
    
    let battleController = BattleController()
    router.get(battleController.rootPathString, Int.parameter, use: battleController.getBattle)
    router.get(battleController.rootPathString, use: battleController.getUserBattles)
    router.post(CreateBattle.self, at: battleController.rootPathString, use: battleController.createBattle)
    
    let battleInitController = BattleInitController()
    router.post(CreateBattleInit.self, at: battleInitController.rootPathString, use: battleInitController.createBattleInit)
    
    let battleTurnController = BattleTurnController()
    router.post(CreateBattleTurn.self, at: battleTurnController.rootPathString, use: battleTurnController.createTurn)
    
    let battleActionController = BattleActionController()
    router.post(CreateBattleAction.self, at: battleActionController.rootPathString, use: battleActionController.createAction)
    
    //GET       challenge
    //GET       challenge/find
    //POST      challenge/initiate/{opponentId}
    //PUT       challenge/accept/{challengeId}
    //PUT       challenge/decline/{challengeId}
}

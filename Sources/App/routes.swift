import Vapor
import JWT
import CCryptoOpenSSL

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get { req in
        return "Info"
    }
    
    let userController = UserController()
    router.get("user", use: userController.getUser)
}

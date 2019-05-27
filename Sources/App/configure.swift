import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(FileMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    // Configure a PostgreSQL database
    let postgreSQLConfig = PostgreSQLDatabaseConfig(
        hostname: "tactics.c811dm4vddhz.us-east-2.rds.amazonaws.com",
        port: 6190,
        username: "kevin",
        database: "tactics",
        password: "lightningstab"
    )
    let postgresql = PostgreSQLDatabase(config: postgreSQLConfig)
    
    /// Register the configured PostgreSQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)
    
    // Configure migrations
    var migrations = MigrationConfig()
    
    migrations.add(model: Battle.self, database: .psql)
    migrations.add(model: BattleInit.self, database: .psql)
    migrations.add(model: BattleTurn.self, database: .psql)
    migrations.add(model: BattleAction.self, database: .psql)
    
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Hero.self, database: .psql)
    migrations.add(model: Challenge.self, database: .psql)
    
    services.register(migrations)
}

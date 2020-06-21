import Vapor
import Fluent
import FluentPostgresDriver
import SwiftLearningCommon
import QueuesRedisDriver

public func configure(_ app: Application) throws {

    guard
        let dbHostname = Environment.get("DB_HOSTNAME"),
        let dbUsername = Environment.get("DB_USERNAME"),
        let dbPassword = Environment.get("DB_PASSWORD"),
        let dbName = Environment.get("DB_NAME")
        else { fatalError("Missing DB info") }

    let tlsConfiguration: TLSConfiguration?
    if let dbCertFilename = Environment.get("DB_CERT_FILENAME") {
        let rootCertificates = try NIOSSLCertificate.fromPEMFile(dbCertFilename)
        tlsConfiguration = TLSConfiguration.forClient(certificateVerification: .noHostnameVerification, trustRoots: .certificates(rootCertificates))
    } else {
        tlsConfiguration = nil
    }

    let configuration = PostgresConfiguration(
        hostname: dbHostname,
        port: 5432,
        username: dbUsername,
        password: dbPassword,
        database: dbName,
        tlsConfiguration: tlsConfiguration
    )
    app.databases.use(.postgres(configuration: configuration), as: .psql)

    app.migrations.add(CreateSchemas())
    app.migrations.add(AddInitialValues())

    if Environment.get("RUN_QUEUE_DRIVER") == "TRUE" {
        app.queues.use(try .redis(url: "redis://127.0.0.1:6379"))
        let rssJob = RSSJob(client: app.client, db: app.db)
        app.queues.add(rssJob)
        try app.queues.startInProcessJobs(on: .default)
    }

    try routes(app)
}

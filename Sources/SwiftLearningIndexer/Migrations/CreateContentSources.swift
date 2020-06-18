import Foundation
import Fluent
import SwiftLearningCommon

struct CreateContentSources: Migration {
    private func createSchema(on database: Database) -> EventLoopFuture<Void> {
        ContentSource.schemaBuilder(for: database).create()
    }

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        createSchema(on: database)
            .flatMap {
                ContentSource.swiftBySundell.create(on: database)
            }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ContentSource.schema).delete()
    }
}

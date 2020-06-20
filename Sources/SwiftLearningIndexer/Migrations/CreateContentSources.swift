import Foundation
import Fluent
import SwiftLearningCommon

struct CreateContentSources: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        ContentSource.schemaBuilder(for: database).create()
            .flatMap {
                ContentSource.swiftBySundell.create(on: database)
            }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ContentSource.schema).delete()
    }
}

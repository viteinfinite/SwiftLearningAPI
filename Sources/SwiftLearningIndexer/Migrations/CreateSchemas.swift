import Foundation
import Fluent
import SwiftLearningCommon

struct CreateSchemas: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        ContentSource.schemaBuilder(for: database).create()
            .flatMap {
                LearningContent.Kind.schemaBuilder(for: database).create()
            }
            .flatMap {
                LearningContent.schemaBuilder(for: database, kind: $0).create()
            }
            .flatMap {
                Author.schemaBuilder(for: database).create()
            }
            .flatMap {
                LearningContentAuthor.schemaBuilder(for: database).create()
            }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(LearningContentAuthor.schema).delete()
            .flatMap {
                database.schema(LearningContent.schema).delete()
            }
            .flatMap {
                database.schema(Author.schema).delete()
            }
    }
}

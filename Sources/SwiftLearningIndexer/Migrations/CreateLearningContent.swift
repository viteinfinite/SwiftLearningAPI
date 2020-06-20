import Foundation
import Fluent
import SwiftLearningCommon

struct CreateLearningContent: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        LearningContent.schemaBuilder(for: database).create()
            .flatMap {
                Author.schemaBuilder(for: database).create()
            }
            .flatMap {
                LearningContentAuthor.schemaBuilder(for: database).create()
            }
            .flatMap {
                LearningContent.Kind.schemaBuilder(for: database).create().map { _ in }
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

import Foundation
import Fluent
import SwiftLearningCommon

struct AddInitialValues: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        AllContentSourceProviders.allContentSourceProviders.map { $0.source }
            .create(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ContentSource.schema).delete()
    }
}

import Foundation
import Fluent

struct CreateLearningContent: Migration {
    private func createLearningContentSchema(on database: Database) -> EventLoopFuture<Void> {
        database.schema("learning_contents")
            .id()
            .field("title", .string)
            .field("kind", .string)
            .field("url", .json)
            .field("source_id", .uuid, .references("content_sources", "id"))
            .create()
    }

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        createLearningContentSchema(on: database)
            .flatMap {
                LearningContent(title: "Vispa teresa", kind: .blogPost, url: URL(string: "http://www.barbo.com")!, sourceId: ContentSourceItem.swiftBySundell.id!)
                    .save(on: database)
            }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("content_sources").delete()
    }
}

import Foundation
import Fluent
import SwiftLearningCommon

struct CreateContentSources: Migration {
    private func createSchema(on database: Database) -> EventLoopFuture<Void> {
        database.schema("content_sources")
            .id()
            .field("name", .string)
            .field("rss_url", .json)
            .field("podcast_url", .json)
            .field("playlist_url", .json)
            .field("website_url", .json)
            .create()
    }

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        createSchema(on: database)
            .flatMap {
                ContentSourceItem.swiftBySundell.create(on: database)
            }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("content_sources").delete()
    }
}

import Foundation
import Fluent

struct CreateContentSources: Migration {
    private func createSchema(on database: Database) -> EventLoopFuture<Void> {
        database.schema("content_sources")
            .id()
            .field("name", .string)
            .field("rssUrl", .json)
            .field("podcastUrl", .json)
            .field("playlistUrl", .json)
            .field("websiteUrl", .json)
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

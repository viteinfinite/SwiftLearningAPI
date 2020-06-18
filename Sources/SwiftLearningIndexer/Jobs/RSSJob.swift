import Foundation
import Vapor
import Queues
import SwiftLearningCommon
import FeedKit
import Fluent

class RSSJob: Job {
    private let client: Client
    private let db: Database

    private func fetchRSS(_ context: QueueContext, payload: [ContentSource]) -> EventLoopFuture<String> {
        guard let url = payload.first?.rssUrl else {
            return context.eventLoop.makeSucceededFuture("FAILED")
        }
        return client.get(URI(string: url.absoluteString)).flatMap { res -> EventLoopFuture<String> in
            let data = Data(buffer: res.body!)
            let parser = FeedParser(data: data)
            let result = parser.parse()
            switch result {
            case .failure(let error):
                return context.eventLoop.makeFailedFuture(error)
            case .success(let feed):
                switch feed {
                case .atom(let atomFeed):
                    return self.createAtomEntriesInDb(entries: atomFeed.entries ?? [], contentSourceId: payload.first!.id!, context: context)
                case .rss(let rssFeed):
                    return self.createRssEntriesInDb(items: rssFeed.items ?? [], contentSourceId: payload.first!.id!, context: context)
                case .json(let jsonFeed):
                    fatalError("not impl")
                }
            }
        }
    }

    private func createAtomEntriesInDb(entries: [AtomFeedEntry], contentSourceId: String, context: QueueContext) -> EventLoopFuture<String> {
        entries
            .compactMap { InsertableBlogPost.from(atomFeedEntry: $0, contentSourceId: contentSourceId) }
            .save(to: db, on: context.eventLoop)
    }

    private func createRssEntriesInDb(items: [RSSFeedItem], contentSourceId: String, context: QueueContext) -> EventLoopFuture<String> {
        items
            .compactMap { InsertableBlogPost.from(rssFeedItem: $0, contentSourceId: contentSourceId) }
            .save(to: db, on: context.eventLoop)
    }

    func dequeue(_ context: QueueContext, _ payload: [ContentSource]) -> EventLoopFuture<Void> {
        fetchRSS(context, payload: payload).map { _ in }
    }

    init(client: Client, db: Database) {
        self.client = client
        self.db = db
    }
}

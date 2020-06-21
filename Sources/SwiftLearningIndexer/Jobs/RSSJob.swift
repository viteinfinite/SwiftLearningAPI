import Foundation
import Vapor
import Queues
import SwiftLearningCommon
import FeedKit
import Fluent

class RSSJob: Job {
    enum Error: Swift.Error {
        case missingUrl(contentSourceId: ContentSourceId)
        case contentSourceProviderNotFound(contentSourceId: ContentSourceId)
    }

    private let client: Client
    private let db: Database

    private func fetchRSS(_ context: QueueContext, payload: [ContentSourceId]) -> EventLoopFuture<Void> {
        return EventLoopFuture.andAllComplete(
            payload.map { fetchRSS(context, contentSourceId: $0) },
            on: context.eventLoop
        )
    }

    private func fetchRSS(_ context: QueueContext, contentSourceId: ContentSourceId) -> EventLoopFuture<Void> {
        guard let contentSourceProvider = AllContentSourceProviders.contentSourceProviderById[contentSourceId] else {
            return context.eventLoop.makeFailedFuture(RSSJob.Error.contentSourceProviderNotFound(contentSourceId: contentSourceId))
        }
        guard let rssUrl = contentSourceProvider.source.rssUrl else {
            return context.eventLoop.makeFailedFuture(RSSJob.Error.missingUrl(contentSourceId: contentSourceId))
        }
        return client.get(URI(string: rssUrl.absoluteString))
            .flatMapThrowing { res -> [IndexableBlogPost] in
                let data = Data(buffer: res.body!)
                let parser = FeedParser(data: data)
                let result = parser.parse()
                switch result {
                case .failure(let error):
                    throw error
                case .success(let feed):
                    switch feed {
                    case .atom(let atomFeed):
                        return atomFeed.entries?
                            .compactMap { IndexableBlogPost.from(atomFeedEntry: $0, contentSourceId: contentSourceId) } ??
                            []
                    case .rss(let rssFeed):
                        return rssFeed.items?
                            .compactMap { IndexableBlogPost.from(rssFeedItem: $0, contentSourceId: contentSourceId) } ??
                            []
                    case .json(let jsonFeed):
                        fatalError("not impl")
                    }
                }
            }
            .flatMap {
                self.createEntriesInDb(
                    context: context,
                    contentSourceProvider: contentSourceProvider,
                    insertableBlogPosts: $0
                )
            }
    }

    private func createEntriesInDb(context: QueueContext, contentSourceProvider: ContentSourceProvider, insertableBlogPosts: [IndexableBlogPost]) -> EventLoopFuture<Void> {
        IndexableBlogPostDBCoordinator.save(
            insertableBlogPosts.map { contentSourceProvider.enrich($0) },
            to: db,
            on: context.eventLoop
        )
    }

    func dequeue(_ context: QueueContext, _ payload: [ContentSourceId]) -> EventLoopFuture<Void> {
        fetchRSS(context, payload: payload)
    }

    init(client: Client, db: Database) {
        self.client = client
        self.db = db
    }
}

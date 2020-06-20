import Foundation
import FeedKit
import SwiftLearningCommon
import Vapor
import Fluent

extension IndexableBlogPost {
    static func from(rssFeedItem: RSSFeedItem, contentSourceId: String) -> Self? {
        guard let urlString = rssFeedItem.link, let url = URL(string: urlString) else { return nil }
        return IndexableBlogPost(
            author: rssFeedItem.author.map { Author(name: $0) },
            learningContent: LearningContent(title: rssFeedItem.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId)
        )
    }

    static func from(atomFeedEntry: AtomFeedEntry, contentSourceId: String) -> Self? {
        guard let urlString = atomFeedEntry.links?.first?.attributes?.href, let url = URL(string: urlString) else { return nil }
        return IndexableBlogPost(
            author: atomFeedEntry.authors?.first?.name.map { Author(name: $0) },
            learningContent: LearningContent(title: atomFeedEntry.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId)
        )
    }
}

extension Array where Element == IndexableBlogPost {
    func save(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        return primaryFutures(to: db, on: eventLoop)
            .flatMap { self.relationshipFutures(to: db, on: eventLoop) }
    }

    private func primaryFutures(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        let futures = flatMap { insertableBlogPost -> [EventLoopFuture<Void>] in
            var futures: [EventLoopFuture<Void>] = [insertableBlogPost.learningContent.save(on: db)]
            if let author = insertableBlogPost.author {
                futures.append(author.save(on: db))
            }
            return futures
        }
        return EventLoopFuture.andAllComplete(futures, on: eventLoop)
    }

    private func relationshipFutures(to db: Database, on eventLoop: EventLoop) ->  EventLoopFuture<Void> {
        let futures = compactMap { insertableBlogPost -> EventLoopFuture<Void>? in
            guard let author = insertableBlogPost.author else { return nil }
            return insertableBlogPost.learningContent.$authors.attach(author, on: db)
        }
        return EventLoopFuture.andAllComplete(futures, on: eventLoop)
    }
}

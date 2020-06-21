import Foundation
import FeedKit
import SwiftLearningCommon
import Vapor
import Fluent

extension IndexableBlogPost {
    static func from(rssFeedItem: RSSFeedItem, contentSourceId: ContentSourceId) -> Self? {
        guard let urlString = rssFeedItem.link, let url = URL(string: urlString) else { return nil }
        return IndexableBlogPost(
            author: rssFeedItem.author.map { Author(name: $0) },
            learningContent: LearningContent(title: rssFeedItem.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId)
        )
    }

    static func from(atomFeedEntry: AtomFeedEntry, contentSourceId: ContentSourceId) -> Self? {
        guard let urlString = atomFeedEntry.links?.first?.attributes?.href, let url = URL(string: urlString) else { return nil }
        return IndexableBlogPost(
            author: atomFeedEntry.authors?.first?.name.map { Author(name: $0) },
            learningContent: LearningContent(title: atomFeedEntry.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId)
        )
    }
}

extension Array where Element == IndexableBlogPost {
    func save(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        return authorFutures(to: db, on: eventLoop)
            .flatMap { self.learningContentFutures(to: db, on: eventLoop) }
    }

    private func authorFutures(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        let uniqueAuthors = Array<Author>(Set(compactMap { $0.author }))
        return EventLoopFuture.andAllComplete(uniqueAuthors.map { $0.save(on: db) }, on: eventLoop)
    }

    private func learningContentFutures(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
        let futures = map { insertableBlogPost -> EventLoopFuture<Void> in
            return insertableBlogPost.learningContent.save(on: db).flatMap {
                guard let author = insertableBlogPost.author else { return eventLoop.makeSucceededFuture(()) }
                return insertableBlogPost.learningContent.$authors.attach(author, on: db)
            }
        }
        return EventLoopFuture.andAllComplete(futures, on: eventLoop)
    }
}

import Foundation
import FeedKit
import SwiftLearningCommon
import Vapor
import Fluent

struct InsertableBlogPost {
    let author: Author?
    let learningContent: LearningContent
}

extension InsertableBlogPost {
    static func from(rssFeedItem: RSSFeedItem, contentSourceId: String) -> Self? {
        guard let urlString = rssFeedItem.link, let url = URL(string: urlString) else { return nil }
        return InsertableBlogPost(
            author: rssFeedItem.author.map { Author(name: $0) },
            learningContent: LearningContent(title: rssFeedItem.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId)
        )
    }

    static func from(atomFeedEntry: AtomFeedEntry, contentSourceId: String) -> Self? {
        guard let urlString = atomFeedEntry.links?.first?.attributes?.href, let url = URL(string: urlString) else { return nil }
        return InsertableBlogPost(
            author: atomFeedEntry.authors?.first?.name.map { Author(name: $0) },
            learningContent: LearningContent(title: atomFeedEntry.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId)
        )
    }
}

extension Array where Element == InsertableBlogPost {
    func save(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<String> {
        let eventLoopFutures = flatMap { insertableBlogPosts -> [EventLoopFuture<Void>] in
            var futures: [EventLoopFuture<Void>] = [insertableBlogPosts.learningContent.save(on: db)]
            if let author = insertableBlogPosts.author {
                futures.append(author.save(on: db))
                futures.append(insertableBlogPosts.learningContent.$authors.attach(author, on: db))
            }
            return futures
        }
        return EventLoopFuture.andAllComplete(eventLoopFutures, on: eventLoop).map { "" }
    }
}

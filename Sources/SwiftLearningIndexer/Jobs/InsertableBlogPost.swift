import Foundation
import FeedKit
import SwiftLearningCommon
import Vapor
import Fluent

struct InsertableBlogPost {
    let sourceIdentifier: ContentSourceIdentifier
    var author: Author?
    var learningContent: LearningContent
}

extension InsertableBlogPost {
    static func from(rssFeedItem: RSSFeedItem, contentSourceId: ContentSourceIdentifier) -> Self? {
        guard let urlString = rssFeedItem.link, let url = URL(string: urlString) else { return nil }
        return InsertableBlogPost(
            sourceIdentifier: contentSourceId,
            author: rssFeedItem.author.map { Author(name: $0) },
            learningContent: LearningContent(title: rssFeedItem.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId.rawValue)
        )
    }

    static func from(atomFeedEntry: AtomFeedEntry, contentSourceId: ContentSourceIdentifier) -> Self? {
        guard let urlString = atomFeedEntry.links?.first?.attributes?.href, let url = URL(string: urlString) else { return nil }
        return InsertableBlogPost(
            sourceIdentifier: contentSourceId,
            author: atomFeedEntry.authors?.first?.name.map { Author(name: $0) },
            learningContent: LearningContent(title: atomFeedEntry.title ?? "", kind: .blogPost, url: url, sourceId: contentSourceId.rawValue)
        )
    }
}

extension Array where Element == InsertableBlogPost {
    func save(to db: Database, on eventLoop: EventLoop) -> EventLoopFuture<String> {
        let enrichedBlogPosts = map { insertableBlogPost -> InsertableBlogPost in
            insertableBlogPost.sourceIdentifier.enrich(blogPost: insertableBlogPost)
        }
        let primaryFutures = enrichedBlogPosts.flatMap { insertableBlogPost -> [EventLoopFuture<Void>] in
            let insertableBlogPost = insertableBlogPost.sourceIdentifier.enrich(blogPost: insertableBlogPost)
            var futures: [EventLoopFuture<Void>] = [insertableBlogPost.learningContent.save(on: db)]
            if let author = insertableBlogPost.author {
                futures.append(author.save(on: db))
            }
            return futures
        }

        return EventLoopFuture.andAllComplete(primaryFutures, on: eventLoop)
            .flatMap {
                let relationFutures = enrichedBlogPosts.compactMap { insertableBlogPost -> EventLoopFuture<Void>? in
                    guard let author = insertableBlogPost.author else { return nil }
                    return insertableBlogPost.learningContent.$authors.attach(author, on: db)
                }
                return EventLoopFuture.andAllComplete(relationFutures, on: eventLoop)
            }
            .map { "" }
    }
}

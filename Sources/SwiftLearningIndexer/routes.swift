import Vapor
import Fluent
import SwiftLearningCommon

func routes(_ app: Application) throws {
    app.get { req in
        return "indexer works!"
    }

    app.get("start") { req -> EventLoopFuture<String> in
        req
            .queue
            .dispatch(
                RSSJob.self,
                Array(AllContentSourceProviders.contentSourceProviderById.keys)
            )
            .map { "done" }
    }
}

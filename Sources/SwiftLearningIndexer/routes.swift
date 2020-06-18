import Vapor
import Fluent
import SwiftLearningCommon

func routes(_ app: Application) throws {
    app.get { req in
        return "indexer works!"
    }

    app.get("start") { req in
        LearningContent.query(on: req.db).all()
    }
}

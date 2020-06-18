import Vapor
import Fluent
import SwiftLearningCommon

func routes(_ app: Application) throws {
    app.get { req in
        return "api works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    app.get("sources") { req in
        ContentSource.query(on: req.db).with(\.$contents).all()
    }

    app.get("contents") { req in
        LearningContent.query(on: req.db).all()
    }
}

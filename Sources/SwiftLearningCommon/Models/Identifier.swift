public struct Identifier<Value>: Hashable, Codable {
    public let string: String

    public init(_ string: String) {
        self.string = string
    }

    public init(from decoder: Decoder) throws {
        let valueContainer = try decoder.singleValueContainer()
        self.string = try valueContainer.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var valueContainer = encoder.singleValueContainer()
        try valueContainer.encode(string)
    }
}

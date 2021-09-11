import Foundation

extension URL {
    var relativeStringDirectoryLevel: Int {
        relativeString
            .split(separator: "/")
            .count - 1
    }
}

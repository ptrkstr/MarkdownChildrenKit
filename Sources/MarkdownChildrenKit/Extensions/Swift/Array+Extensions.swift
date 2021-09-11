
extension Array {
    func removingAll(where shouldBeRemoved: (Element) throws -> Bool) rethrows -> Self {
        var array = self
        try array.removeAll(where: shouldBeRemoved)
        return array
    }
}

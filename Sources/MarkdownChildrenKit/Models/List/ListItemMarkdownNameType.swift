public enum ListItemMarkdownNameType: String, CaseIterable {
    /// Exception should be thrown if this isn't met
    case useH1
    
    /// Try find first h1, otherwise use filename
    case useH1withFilenameFallback
    
    /// Use filename
    case useFilename
}

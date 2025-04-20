import Foundation

struct ClipboardItem: Identifiable, Equatable {
    let id: UUID
    let content: String
    var isFavorite: Bool = false
    let dateCopied: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.dateCopied = Date()
    }
}

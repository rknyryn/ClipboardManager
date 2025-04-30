import Foundation

struct ClipboardItem: Identifiable, Equatable, Codable {
    let id: UUID
    let content: String
    var isFavorite: Bool = false
    let dateCopied: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.dateCopied = Date()
    }
    
    init(id: UUID, content: String, isFavorite: Bool, dateCopied: Date) {
        self.id = id
        self.content = content
        self.isFavorite = isFavorite
        self.dateCopied = dateCopied
    }
}

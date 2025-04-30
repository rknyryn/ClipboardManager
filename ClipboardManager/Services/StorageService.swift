import Foundation

protocol StorageServiceProtocol {
    func saveFavorites(_ items: [ClipboardItem]) throws
    func loadFavorites() throws -> [ClipboardItem]
}

final class StorageService: StorageServiceProtocol {
    private let fileManager: FileManager
    private let favoritesURL: URL
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.favoritesURL = documentsDirectory.appendingPathComponent("favorites.json")
    }
    
    func saveFavorites(_ items: [ClipboardItem]) throws {
        let data = try JSONEncoder().encode(items)
        try data.write(to: favoritesURL)
    }
    
    func loadFavorites() throws -> [ClipboardItem] {
        guard fileManager.fileExists(atPath: favoritesURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: favoritesURL)
        return try JSONDecoder().decode([ClipboardItem].self, from: data)
    }
} 
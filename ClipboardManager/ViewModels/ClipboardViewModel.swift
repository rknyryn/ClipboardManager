import Foundation
import AppKit

class ClipboardViewModel: ObservableObject {
    @Published var items: [ClipboardItem] = []
    @Published var searchText: String = ""
    
    private var lastContent: String = ""
    private let pasteboard = NSPasteboard.general
    private var timer: Timer?
    private let favoritesURL: URL
    
    init() {
        // Favori dosyasının URL'sini oluştur
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        favoritesURL = documentsDirectory.appendingPathComponent("favorites.json")
        
        // Favori öğeleri yükle
        loadFavorites()
        
        if let initialContent = pasteboard.string(forType: .string) {
            let newItem = ClipboardItem(content: initialContent)
            items.insert(newItem, at: 0)
            lastContent = initialContent
        }
        
        startMonitoringClipboard()
    }
    
    private func loadFavorites() {
        do {
            if FileManager.default.fileExists(atPath: favoritesURL.path) {
                let data = try Data(contentsOf: favoritesURL)
                let favorites = try JSONDecoder().decode([ClipboardItem].self, from: data)
                
                // Favori öğeleri items listesine ekle
                for favorite in favorites {
                    if !items.contains(where: { $0.id == favorite.id }) {
                        items.append(favorite)
                    }
                }
            }
        } catch {
            print("Favori öğeler yüklenirken hata oluştu: \(error)")
        }
    }
    
    private func saveFavorites() {
        do {
            let favorites = items.filter { $0.isFavorite }
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: favoritesURL)
        } catch {
            print("Favori öğeler kaydedilirken hata oluştu: \(error)")
        }
    }
    
    func startMonitoringClipboard() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    func checkClipboard() {
        if let clipboardString = pasteboard.string(forType: .string),
           clipboardString != lastContent {
            let newItem = ClipboardItem(content: clipboardString)
            DispatchQueue.main.async { [weak self] in
                self?.items.insert(newItem, at: 0)
                self?.lastContent = clipboardString
            }
        }
    }
    
    func copyToClipboard(_ content: String) {
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        lastContent = content
    }
    
    func filteredItems() -> [ClipboardItem] {
        let filtered = items.filter { item in
            searchText.isEmpty || item.content.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            if first.isFavorite == second.isFavorite {
                return first.dateCopied > second.dateCopied
            } else {
                return first.isFavorite && !second.isFavorite
            }
        }
    }
    
    func toggleFavorite(_ item: ClipboardItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isFavorite.toggle()
            saveFavorites()
        }
    }
    
    func delete(_ item: ClipboardItem) {
        items.removeAll { $0.id == item.id }
        saveFavorites()
    }
    
    func deleteAll() {
        items.removeAll { !$0.isFavorite }
        saveFavorites()
    }
    
    deinit {
        timer?.invalidate()
        saveFavorites()
    }
}

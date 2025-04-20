import Foundation
import AppKit

class ClipboardViewModel: ObservableObject {
    @Published var items: [ClipboardItem] = []
    @Published var searchText: String = ""
    
    private var lastContent: String = ""
    private let pasteboard = NSPasteboard.general
    private var timer: Timer?

    init() {
        // Başlangıçta mevcut pano içeriğini kontrol et
        if let initialContent = pasteboard.string(forType: .string) {
            let newItem = ClipboardItem(content: initialContent)
            items.insert(newItem, at: 0)
            lastContent = initialContent
        }
        
        // Pano içeriği değiştiğinde kontrol et
        startMonitoringClipboard()
    }
    
    func startMonitoringClipboard() {
        // Timer ile her saniye pano kontrolü yapılacak
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
    
    func delete(_ item: ClipboardItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func deleteAll() {
        items.removeAll()
    }
    
    deinit {
        // Timer'ı temizle
        timer?.invalidate()
    }
}

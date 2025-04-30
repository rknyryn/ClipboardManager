import Foundation
import AppKit
import Combine

protocol ClipboardViewModelProtocol: ObservableObject {
    var items: [ClipboardItem] { get }
    var searchText: String { get set }
    func toggleFavorite(_ item: ClipboardItem)
    func delete(_ item: ClipboardItem)
    func deleteAll()
    func copyToClipboard(_ content: String)
    func checkClipboard()
}

final class ClipboardViewModel: ClipboardViewModelProtocol {
    @Published private(set) var items: [ClipboardItem] = []
    @Published var searchText: String = ""
    
    private let storageService: StorageServiceProtocol
    private let pasteboard: NSPasteboard
    private var lastContent: String = ""
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init(
        storageService: StorageServiceProtocol = StorageService(),
        pasteboard: NSPasteboard = .general
    ) {
        self.storageService = storageService
        self.pasteboard = pasteboard
        
        setupInitialContent()
        loadFavorites()
        startMonitoringClipboard()
        setupBindings()
    }
    
    private func setupInitialContent() {
        if let initialContent = pasteboard.string(forType: .string) {
            let newItem = ClipboardItem(content: initialContent)
            items.insert(newItem, at: 0)
            lastContent = initialContent
        }
    }
    
    private func loadFavorites() {
        do {
            let favorites = try storageService.loadFavorites()
            favorites.forEach { favorite in
                if !items.contains(where: { $0.id == favorite.id }) {
                    items.append(favorite)
                }
            }
        } catch {
            print("Favori öğeler yüklenirken hata oluştu: \(error)")
        }
    }
    
    private func saveFavorites() {
        do {
            let favorites = items.filter { $0.isFavorite }
            try storageService.saveFavorites(favorites)
        } catch {
            print("Favori öğeler kaydedilirken hata oluştu: \(error)")
        }
    }
    
    private func setupBindings() {
        $items
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveFavorites()
            }
            .store(in: &cancellables)
    }
    
    private func startMonitoringClipboard() {
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
        }
    }
    
    func delete(_ item: ClipboardItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func deleteAll() {
        items.removeAll { !$0.isFavorite }
    }
    
    deinit {
        timer?.invalidate()
        saveFavorites()
    }
}

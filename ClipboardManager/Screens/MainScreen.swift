import SwiftUI

struct MainScreen: View {
    @StateObject private var viewModel = ClipboardViewModel()
    @State private var settingsWindow: NSWindow?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Arama...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    openSettingsWindow();
                }) {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            
            if viewModel.filteredItems().isEmpty {
                VStack {
                    Spacer()
                    Text(viewModel.searchText.isEmpty ? "Henüz kopyalanmış içerik yok." : "Sonuç bulunamadı.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
            } else {
                List {
                    ForEach(viewModel.filteredItems()) { item in
                        ClipboardRowView(
                            item: item,
                            onDelete: {
                                viewModel.delete(item)
                            },
                            onCopy: {
                                viewModel.copyToClipboard(item.content)
                            }
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            
            if viewModel.items.isEmpty == false {
                Divider();
                Button(action: {
                    viewModel.deleteAll()
                }) {
                    Text("Tümünü Temizle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(5)
            }
        }
        .frame(width: 300, height: 450)
        .onAppear {
            viewModel.checkClipboard()
        }
    }
    
    private func openSettingsWindow() {
        if let window = settingsWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            return
        }

        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(
            contentViewController: hostingController
        )
        window.title = "Ayarlar"
        window.setContentSize(NSSize(width: 400, height: 300))
        window.styleMask.insert(.closable)
        window.styleMask.insert(.resizable)
        window.styleMask.insert(.titled)
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)

        self.settingsWindow = window

        NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: window, queue: .main) { _ in
            settingsWindow = nil
        }
    }
}

import SwiftUI

struct SettingsScreen: View {
    @State private var launchAtLogin = LaunchAtLoginManager.shared.isEnabled()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Uygulama Başlangıcı")
                        .font(.headline)
                    
                    Text("Bu uygulama, sistem başlangıcında otomatik olarak açılacaktır.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Toggle(isOn: $launchAtLogin) {
                        Text("Başlangıçta çalıştır")
                    }
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: launchAtLogin) {
                        LaunchAtLoginManager.shared.enableLaunchAtLogin(launchAtLogin)
                    }
                }
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    Link("Kaan Yarayan", destination: URL(string: "https://github.com/rknyryn")!)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .underline(false)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.secondary)
                    Text("Sürüm 1.0.0")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Text("© 2025 Kaan Yarayan. Tüm hakları saklıdır.")
                    .font(.caption2) // Daha küçük ve hafif yazı
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

        }
        .padding(24)
        .frame(width: 400, height: 360)
    }
}

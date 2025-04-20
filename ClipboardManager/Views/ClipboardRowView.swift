import SwiftUI

struct ClipboardRowView: View {
    let item: ClipboardItem
    var onDelete: (() -> Void)? = nil
    var onCopy: (() -> Void)? = nil
    
    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        HStack {
            Text(item.content)
                .lineLimit(1)
            
            Spacer()
            
            if isHovered {
                Button(action: {
                    onDelete?()
                }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(4)
        .background(isHovered ? Color.gray.opacity(0.15) : Color.clear)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .cornerRadius(4)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            onCopy?()
        }
    }
}

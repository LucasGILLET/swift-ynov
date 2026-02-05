// TP2 - Card Game System
// Package Entry Point

struct CardGamePackage {
    @MainActor static func main() {
        CardGameManager.shared.run()
    }
}

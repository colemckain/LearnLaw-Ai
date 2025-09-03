import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0.0
    
    // American flag colors
    private let americanRed = Color(red: 0.698, green: 0.133, blue: 0.133) // #B22222
    private let americanBlue = Color(red: 0.235, green: 0.353, blue: 0.588) // #3C5A96
    private let americanWhite = Color.white
    
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                // American flag background image
                Image("splash-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .overlay(
                        // Semi-transparent overlay to ensure text readability
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                    )
                
                VStack(spacing: 30) {
                    // App Icon (no circle background)
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    .scaleEffect(logoScale)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    // App Name
                    Text("LearnLaw Ai")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(textOpacity)
                        .shadow(color: .black, radius: 3, x: 0, y: 2)
                    
                    // Tagline
                    Text("Your AI-Powered Legal Companion")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity)
                        .shadow(color: .black, radius: 2, x: 0, y: 1)
                    
                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .opacity(textOpacity)
                }
                .padding()
            }
            .onAppear {
                // Animate logo scale
                withAnimation(.easeOut(duration: 0.8)) {
                    logoScale = 1.0
                }
                
                // Animate text opacity
                withAnimation(.easeIn(duration: 0.6).delay(0.4)) {
                    textOpacity = 1.0
                }
                
                // Navigate to main app after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
} 
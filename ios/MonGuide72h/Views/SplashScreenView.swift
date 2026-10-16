import SwiftUI

public struct SplashScreenView: View {
    @State private var isActive: Bool = UserDefaults.standard.bool(forKey: "skipSplash")
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var footerOpacity: Double = 0.0
    @State private var progressValue: Double = 0.0
    
    public init() {}
    
    public var body: some View {
        ZStack {
            if isActive {
                MainTabView()
                    .transition(.opacity)
            } else {
                splashContent
                    .transition(.opacity)
            }
        }
    }
    
    private var splashContent: some View {
        ZStack {
            // Background: Official Deep Luxembourg Navy
            Color(red: 0/255, green: 43/255, blue: 73/255)
                .ignoresSafeArea()
            
            // Subtle Radial Lighting in Center
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0/255, green: 75/255, blue: 125/255).opacity(0.6),
                    Color(red: 0/255, green: 30/255, blue: 55/255)
                ]),
                center: .center,
                startRadius: 20,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Central App Badge / Logo
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 135, height: 135)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                    )
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                // Main Title & Subtitles
                VStack(spacing: 8) {
                    Text("MON GUIDE 72H")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(1.5)
                    
                    HStack(spacing: 6) {
                        Text("LËTZ PREPARE !")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(Color.yellow)
                        
                        Text("•")
                            .foregroundColor(.white.opacity(0.4))
                        
                        Text("72H D'AUTONOMIE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Text("STRATÉGIE NATIONALE DE RÉSILIENCE")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Color(red: 0/255, green: 161/255, blue: 222/255)) // Luxembourg Cyan
                        .tracking(2)
                        .padding(.top, 2)
                }
                .opacity(textOpacity)
                
                // Subtle Progress Line
                VStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 3)
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.yellow, Color(red: 0/255, green: 161/255, blue: 222/255)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * CGFloat(progressValue), height: 3)
                        }
                    }
                    .frame(width: 140, height: 3)
                }
                .padding(.top, 10)
                .opacity(textOpacity)
                
                Spacer()
                
                // Footer: InfoReis Brand Logo
                VStack(spacing: 8) {
                    Image("InfoReisLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 46)
                        .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 2)
                    
                    Text("Développé par InfoReis • Renato Reis")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }
                .opacity(footerOpacity)
                .padding(.bottom, 28)
            }
        }
        .onAppear {
            runAnimationSequence()
        }
    }
    
    private func runAnimationSequence() {
        // Logo Spring
        withAnimation(.spring(response: 0.7, dampingFraction: 0.65, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text Fade-in
        withAnimation(.easeOut(duration: 0.6).delay(0.25)) {
            textOpacity = 1.0
        }
        
        // Progress bar smooth fill
        withAnimation(.easeInOut(duration: 1.6).delay(0.3)) {
            progressValue = 1.0
        }
        
        // Footer Fade-in
        withAnimation(.easeIn(duration: 0.6).delay(0.5)) {
            footerOpacity = 1.0
        }
        
        // Transition to MainTabView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.4)) {
                isActive = true
            }
        }
    }
}

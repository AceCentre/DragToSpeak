//
//  OnboardingView.swift
//  DragToSpeak
//
//  Created by Will Wade on 26/01/2024.
//
import SwiftUI
import WebKit


struct DemoGif: UIViewRepresentable {
    var videoName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        if let url = Bundle.main.url(forResource: videoName, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                
                webView.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent()
                )
            } catch {
                print("An error occurred whilst loading image")
            }
            webView.scrollView.isScrollEnabled = false
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }

}


struct OnboardingPage: View {
    @Binding var hasLaunchedBefore: Bool
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if horizontalSizeClass == .compact {
                    DemoGif(videoName: "PortraitVideo").aspectRatio(600 / 1297, contentMode: .fit)
                } else {
                    DemoGif(videoName: "LandscapeVideo").aspectRatio(600 / 278, contentMode: .fit)
                }
                Spacer()
            }
            
            
            Button("Continue") {
                hasLaunchedBefore = true
            }.buttonStyle(.borderedProminent)
        }
    }
}

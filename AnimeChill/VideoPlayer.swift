//
//  VideoPlayer.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import AVKit
import SwiftUI

struct MyVideoPlayer: View {
    let id: String
    let url: String
    
    init(id: String, url: String) {
        self.id = id
        self.url = url
#if !os(macOS)
        try? AVAudioSession.sharedInstance().setCategory(
            .playback,
            mode: .moviePlayback,
            options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP]
        )
#endif
    }
    
    var body: some View {
        VideoPlayerView(url: url)
            .navigationTitle(id)
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
                Menu {
                    ShareLink(item: URL(string: url)!, message: Text(id))
                    Link("Link to \(id)", destination: URL(string: url)!)
                } label: {
                    Label("Actions", systemImage: "ellipsis.circle")
                }
            }
    }
}

#if os(macOS)
struct VideoPlayerView: NSViewRepresentable {
    let url: String
    
    func makeNSView(context: Context) -> AVPlayerView {
        let playerVC = AVPlayerView()
        playerVC.player = AVPlayer(url: URL(string: url)!)
        playerVC.allowsPictureInPicturePlayback = true
        playerVC.showsFullScreenToggleButton = true
        playerVC.showsSharingServiceButton = true
        playerVC.player?.preventsDisplaySleepDuringVideoPlayback = true
        return playerVC
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) { }
}
#else
struct VideoPlayerView: UIViewControllerRepresentable {
    let url: String
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = AVPlayer(url: URL(string: url)!)
        vc.allowsPictureInPicturePlayback = true
        vc.entersFullScreenWhenPlaybackBegins = true
        vc.exitsFullScreenWhenPlaybackEnds = true
        vc.player?.preventsDisplaySleepDuringVideoPlayback = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}
#endif

#Preview {
    NavigationStack {
        MyVideoPlayer(id: "Something?", url: "https://an.bigtimedelivery.net/_v13/7d0b992f51e49aa62c052e9f5f396d7aebd905fbb5d934e38421a9af828d4842fe3a0a403e348332c54bc05acfbcaab8f78a4104caa722feb9f01c0c44529f5101603a0d2d3b5701c99343158ed42afe7c998c518672622ca5f2e54a4273c6670545c62cbf8c8e2d787f5f4b7bbb80b3a260f822130dff89cb81b78ce786dc84f2daf9e53bc6bccc14fee7df243a981c/720/index.m3u8")
    }
}

//
//  ViewController.swift
//  operate_music_ios
//
//  Created by ibuki iida on 2020/01/19.
//  Copyright © 2020 ibuki iida. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation


class ViewController: UIViewController {
    
    var AVAplayer:AVAudioPlayer = AVAudioPlayer()
    var player: MPMusicPlayerController!
    let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    
    @IBOutlet weak var skipToNext: UIButton!
    @IBOutlet weak var skipToPreviousItem: UIButton!
//    @IBOutlet weak var playAndSuspend: UIButton!
//    @IBOutlet weak var favoriteMusic: UIButton!
//    @IBOutlet weak var transitionPleference: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutInit()
        
        
        // なんかよくわからないけど、フォアグラウンドになったことを通知する
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.viewWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification, object: nil
        )
        
        player = MPMusicPlayerController.systemMusicPlayer
        player.repeatMode = .none
        
        // なんかよくわからないけど、曲が変わったタイミングで通知を受け取る
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(type(of: self).nowPlayingItemChanged(notification:)),
            name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player
        )
        // なんかよくわからないけど、これを書かないと自動的に次の曲になった時に通知されない
        // これは後で"end"する必要があるの？
        player.beginGeneratingPlaybackNotifications()
        
        // 起動時に曲を情報を表示する
        if let playingitem = player.nowPlayingItem {
            updateMusicInfo(mediaItem: playingitem)
        }
        
    }
    
    // 再生中の曲が変更された時に実行
    @objc func nowPlayingItemChanged(notification:NSNotification) {
        print("曲が更新された")
        // FIXME もし再生できる状態なら（これが至る場所にあるからまとめたし）
        if let playingitem = player.nowPlayingItem {
            updateMusicInfo(mediaItem: playingitem)
        }
    }
    // 曲の情報を更新する
    func updateMusicInfo(mediaItem: MPMediaItem) {
        print("曲の情報を更新")
        musicTitle.text = mediaItem.title ?? "不明なタイトル"
        musicArtist.text = mediaItem.artist ?? "不明なアーティスト"
    }
    
    // フォアグラウンドになったことの通知を受け取ったら曲情報を更新
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {
            if let playingitem = player.nowPlayingItem {
                updateMusicInfo(mediaItem: playingitem)
            }
            print("フォアグラウンド")
        }
    }
    
    // [ボタン]次の曲に
    @IBAction func onSkipToNext(_ sender: Any) {
        player.skipToNextItem()
    }
    // [ボタン]前の曲に
    @IBAction func onSkipToPreviousItem(_ sender: Any) {
        player.skipToPreviousItem()
    }
    // [ボタン]再生と一時停止
//    @IBAction func onPlayAndSuspend(_ sender: Any) {
//        print("再生/一時停止")
//        musicPlayer.pause()
//        if(AVAplayer.isPlaying){
//            print("一時停止")
//            musicPlayer.pause()
//        }else{
//            print("再生")
//            musicPlayer.play()
//        }
//    }
    
    // [ボタン]お気に入り（再生リストに追加）
//    @IBAction func onFavoriteMusic(_ sender: Any) {
//    }
    
    // [ボタン]（設定画面に遷移）
//    @IBAction func onTransitionPleference(_ sender: Any) {
//    }
    
    // 後で設定に移せるものは移す
    func layoutInit(){
        musicArtist.adjustsFontSizeToFitWidth = true
        musicTitle.adjustsFontSizeToFitWidth = true
        
//        view.backgroundColor = UIColor.init(red: 255/255, green: 242/255, blue: 229/255, alpha:100/100)
        skipToNext.layer.cornerRadius = 10.0
        skipToPreviousItem.layer.cornerRadius = 10.0
        self.skipToNext.setImage(UIImage(named:"next"), for: .normal)
        self.skipToPreviousItem.setImage(UIImage(named:"previousItem"), for: .normal)
        
//        なんか上手くいかない
//        if(AVAplayer.isPlaying){
//            self.playAndSuspend.setImage(UIImage(named:"teishi"), for: .normal)
//        }else{
//            self.playAndSuspend.setImage(UIImage(named:"saisei"), for: .normal)
//        }
        
        //        skipToNext.imageView?.contentMode = .scaleAspectFit
        //        skipToNext.contentHorizontalAlignment = .fill
        //        skipToNext.contentVerticalAlignment = .fill
        //        skipToNext.imageEdgeInsets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);
        //        skipToNext.imageEdgeInsets = UIEdgeInsets(top: 50,left: 50,bottom: 50,right: 50);
    }
}


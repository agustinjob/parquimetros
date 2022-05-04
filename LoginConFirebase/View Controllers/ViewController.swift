//
//  ViewController.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 23/12/19.
//  Copyright © 2019 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var videoplayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    @IBOutlet weak var signUpBottom: UIButton!
    @IBOutlet weak var loginBottom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
     override func viewWillAppear(_ animated: Bool) {
        // Set up video in the background
        setUpVideo()
    }
    func setUpElements(){
      Utilities.styleFilledButton(signUpBottom)
        Utilities.styleHollowButton(loginBottom)
    }

    func setUpVideo(){
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        guard bundlePath != nil else{
        return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        // Create the video pleyer item
        let item = AVPlayerItem(url: url)
        
        // create the player
        let videoPlayer = AVPlayer(playerItem: item)
        // create the layer
        let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        // Create the size and frame
        videoPlayerLayer.frame = CGRect(x: -self.view.frame.size.width * 1.5, y: 0, width: self.view.frame.size.width * 4 , height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer, at: 0)
        
        // Add it to the view and play it
        videoPlayer.playImmediately(atRate: 0.3)
    }

}


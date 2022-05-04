//
//  SplashScreenViewController.swift
//  LoginConFirebase
//
//  Created by Kevin on 04/03/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit
import AVKit

class SplashScreenViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    let splash = "SplashToLogin"
    let newViewController = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpVideo()
    }
    
    func setUpVideo(){
        
        let bundlePath = Bundle.main.path(forResource: "Splash_Screens _03", ofType: "mp4")
        
        guard bundlePath != nil else{
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        let item = AVPlayerItem(url: url)
        
        videoPlayer = AVPlayer(playerItem: item)
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        
        videoPlayerLayer?.frame = self.view.frame
        videoPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPlayerLayer?.zPosition = 999
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.3, execute: {
            self.videoPlayerLayer?.removeFromSuperlayer()
            self.performSegue(withIdentifier: self.splash, sender: self)
            
           
        })
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

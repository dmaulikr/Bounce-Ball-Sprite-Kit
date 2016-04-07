//
//  GameViewController.swift
//  BallAdventure
//
//  Created by gangyeol kim on 2016. 1. 27..
//  Copyright (c) 2016년 gangyeol kim. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController , GADInterstitialDelegate{

    var interstitial:GADInterstitial?
    var banner: GADBannerView!
    var adIsShowing = Bool()
    
    func addPlayTime(){
        
        StaticVariable.playTime++
    }
    
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        
        adIsShowing = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "addPlayTime", userInfo: nil, repeats: true)

        if let scene = GameScene(fileNamed:"Round1") {

            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            skView.ignoresSiblingOrder = true
        
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
            
            loadBanner()
            
            createAndLoadAd()
            
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "checkDieCount", userInfo: nil, repeats: true)
            
        }
    }
    
    func checkDieCount(){
        
        if((StaticVariable.dieAndClearCount+1) % 10 == 0){
            
            showInterStitial()
            
        }
        
    }
    
    func showInterStitial(){
        
        if(self.interstitial!.isReady){
            
            self.interstitial!.presentFromRootViewController(self)
            StaticVariable.dieAndClearCount++
            
            
        }
        else{
            

            
        }
        
        
    }
    
    func createAndLoadAd(){
    
        interstitial = GADInterstitial(adUnitID:  "ca-app-pub-3105106005990105/5078938471")
        
        let request = GADRequest()
        
//        request.testDevices = ["cad45a94730ccc74e3aecdd0bfa94660"]
        interstitial?.delegate = self // 이게 꼭 있어야 한다..
        interstitial!.loadRequest(request)
        
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        
        createAndLoadAd()
        
    }
    
    
    func loadBanner(){
        
        banner = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        banner.adUnitID = "ca-app-pub-3105106005990105/5078938471"
        banner.rootViewController = self
        
        let req:GADRequest = GADRequest()
        banner.loadRequest(req)

        banner.frame = CGRectMake(0, 0, banner.frame.size.width, banner.frame.size.height)
        
        self.view.addSubview(banner)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

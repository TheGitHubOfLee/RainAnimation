//
//  ViewController.swift
//  RainAnimation
//
//  Created by kevin on 2020/5/13.
//  Copyright © 2020 keivn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let rainAni = RainAnimationView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.addSubview(rainAni)
        rainAni.isUserInteractionEnabled = false
        rainAni.image = UIImage.init(named: "godDog")!
        rainAni.stopAnimation = { [weak self] in
            if let BKYweakself = self {
                BKYweakself.rainAni.removeFromSuperview()
            }
        }
        rainAni.startAnimation()
    }

}


//
//  ViewController.swift
//  AVFoundationPlay
//
//  Created by Gene De Lisa on 1/8/16.
//  Copyright © 2016 Gene De Lisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var sound:Sound!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sound = Sound()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func togglePlayer(sender: UIButton) {
        sound.toggleAVPlayer()
    }
}


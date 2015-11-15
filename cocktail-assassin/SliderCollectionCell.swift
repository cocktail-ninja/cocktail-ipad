//
//  SliderCollectionCell.swift
//  cocktail-assassin
//
//  Created by Colin Harris on 27/10/15.
//  Copyright © 2015 tw. All rights reserved.
//

import UIKit

class SliderCollectionCell: UICollectionViewCell {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var sliderLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    var secondsRemaining: Int = 0
    var timer: NSTimer?
    
    func showSlider() {
        slider.hidden = false
        progressBar.hidden = true
        sliderLabel.text = "Run for \(Int(slider.value)) seconds"
        self.progressBar.setProgress(0.0, animated: false)
        startButton.enabled = true
    }
    
    func animateProgressWithDuration(duration: NSTimeInterval) {
        secondsRemaining = Int(duration)
        slider.hidden = true
        progressBar.hidden = false
        startButton.enabled = false
        UIView.animateWithDuration(
            duration,
            animations: {
                self.progressBar.setProgress(1.0, animated: true)
            }
        )
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func tick() {
        if secondsRemaining <= 0 {
            timer?.invalidate()
            showSlider()
        } else {
            sliderLabel.text = "Cleaning...    (\(secondsRemaining) sec remaining)"
            secondsRemaining--
        }
    }
    
}
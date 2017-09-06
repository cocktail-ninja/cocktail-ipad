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
    var timer: Timer?
    
    func showSlider() {
        slider.isHidden = false
        progressBar.isHidden = true
        sliderLabel.text = "Run for \(Int(slider.value)) seconds"
        self.progressBar.setProgress(0.0, animated: false)
        startButton.isEnabled = true
    }
    
    func animateProgressWithDuration(_ duration: TimeInterval) {
        secondsRemaining = Int(duration)
        slider.isHidden = true
        progressBar.isHidden = false
        startButton.isEnabled = false
        UIView.animate(
            withDuration: duration,
            animations: {
                self.progressBar.setProgress(1.0, animated: true)
            }
        )
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SliderCollectionCell.tick), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func tick() {
        if secondsRemaining <= 0 {
            timer?.invalidate()
            showSlider()
        } else {
            sliderLabel.text = "Cleaning...    (\(secondsRemaining) sec remaining)"
            secondsRemaining -= 1
        }
    }
    
}

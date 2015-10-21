//
//  PouringViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/3/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit
import iOSSharedViewTransition
import PromiseKit

class PouringViewController: UIViewController, ASFSharedViewTransitionDataSource {
    let SUCCESS_ANIMATION_DURATION = 2.0
    let pouringView = PouringView(frame: Constants.drinkFrames.basicFrame),
        successView = GlowingView(frame: Constants.drinkFrames.basicFrame),
        duration : Double?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(drink: Drink, duration: Double) {
        self.duration = duration
        super.init(nibName: nil, bundle: nil)

        let drinkImage = drink.image();
        pouringView.setImage(drinkImage)
        successView.setImage(drinkImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(pouringView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animatePouring()
            .then(addSuccessView)
            .then(animateSuccess)
            .then(dismiss)
    }
    
    func animatePouring() -> Promise<Bool> {
        return pouringView.animate(duration!)
    }
    
    func addSuccessView(finished: Bool) -> Promise<Bool> {
        view.addSubview(successView)
        return Promise<Bool>(true)
    }
    
    func animateSuccess(finished: Bool) -> Promise<Bool> {
        return successView.animate(SUCCESS_ANIMATION_DURATION)
    }
    
    func dismiss(finished: Bool) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func sharedView() -> UIView! {
        return pouringView
    }    
}

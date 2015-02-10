//
//  DrinkDetailsViewController.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 1/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//

import UIKit

class DrinkDetailsViewController: UIViewController {
    let drinkImageView = UIImageView(),
        backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton,
        pourButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton,
        pouringView = PouringView(frame: Constants.drinkFrames.expandedFrame),
        plzHide = UIView(),
        glow = UIImageView()

    var dismissDelegate : ViewControllerDismissDelegate?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(drink: Drink) {
        super.init()
        
        plzHide.frame = view.frame
        
        drinkImageView.frame = Constants.drinkFrames.expandedFrame
        drinkImageView.contentMode = .ScaleAspectFit
        drinkImageView.image = UIImage(named: drink.image)
        
        backButton.setTitle("〈", forState: .Normal)
        backButton.titleLabel?.font = UIFont.systemFontOfSize(40)
        backButton.frame = CGRectMake(30, 80, 100, 60)
        
        pourButton.setTitle("Hit me", forState: .Normal)
        pourButton.titleLabel?.font = UIFont(name: "OpenSans", size: 32)
        pourButton.frame = CGRectMake(620, 650, 300, 60)
        pourButton.backgroundColor = UIColor.darkGrayColor()
        pourButton.titleLabel?.textColor = UIColor.whiteColor()
        
        var label = UILabel(frame: CGRectMake(500, 100, 500, 50))
        label.text = drink.name
        label.font = UIFont(name: "OpenSans", size: 28)
        label.textAlignment = .Center
        plzHide.addSubview(label)
        
        var ingredients = ["Vodka", "Rum", "Lemon Juice", "Cola"]
        
        var y : CGFloat = 0
        for ing in ingredients {
            var slider = UISlider(),
                label = UILabel()
            
            slider.frame = CGRectMake(660, 220 + y, 250, 20)
            slider.setValue(0.5, animated: false)
            
            label.frame = CGRectMake(440, 220 + y, 200, 20)
            label.textAlignment = .Right
            label.font = UIFont(name: "OpenSans", size: 16)
            label.text = ing

            
            y += 70
            
            plzHide.addSubview(label)
            plzHide.addSubview(slider)
        }
        
        pouringView.setImage(drinkImageView.image!)
        pouringView.alpha = 0
        
        glow.image = UIImage(named: "glow.png")
        glow.frame = CGRectMake((view.frame.width - 600)/2, (view.frame.height - 600)/2, 600, 600)
        glow.contentMode = .ScaleAspectFit
        glow.hidden = true
        
        backButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        pourButton.addTarget(self, action: "pour", forControlEvents: .TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(glow)
        view.addSubview(drinkImageView)
        plzHide.addSubview(pourButton)
        plzHide.addSubview(backButton)
        view.addSubview(pouringView)
        view.addSubview(plzHide)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("viewDidAppear")
        

    }
    
    func dismiss(){
        dismissViewControllerAnimated(false, completion: { complete in
            println("dismissed")
            self.dismissDelegate?.onViewControllerDismiss(1)
        })
    }
    
    func pour(){
        println("pour")
        
        var haha = Constants.drinkFrames.basicFrame
        haha.origin = CGPointZero
        
        
        UIView.transitionWithView(self.view,
            duration: 0.2,
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
                self.plzHide.alpha = 0
                self.pouringView.alpha = 1
                self.pouringView.frame = Constants.drinkFrames.basicFrame
                self.pouringView.bwImageView.frame  = haha
                self.pouringView.imageView.frame  = haha
                self.pouringView.bwImageContainer.frame  = haha
                
                self.drinkImageView.alpha = 0
                self.drinkImageView.frame = Constants.drinkFrames.basicFrame
            }, completion: { finished in
                self.pouringView.animate(4, onComplete: {
                    self.glow.hidden = false
                    UIView.transitionWithView(self.view,
                        duration: 2,
                        options: UIViewAnimationOptions.CurveLinear,
                        animations: {
                            self.glow.transform = CGAffineTransformRotate(self.glow.transform, 1/2 * 3.1415926)
                            self.glow.alpha = 0
                        }, completion: { complete in
                            
                            self.dismissDelegate?.onViewControllerDismiss(3)
        
                            self.dismissViewControllerAnimated(false, completion: { complete in
                                println("dismissed")
                                self.dismissDelegate?.onViewControllerDismiss(2)
                            })
                            
                    })
                 })
            })
        }
}
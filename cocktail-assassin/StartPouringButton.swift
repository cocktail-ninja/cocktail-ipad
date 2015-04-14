import UIKit
import MONActivityIndicatorView

enum StartPouringButtonState {
    case Normal
    case Loading
    case Error
}

class StartPouringButton : UIButton, MONActivityIndicatorViewDelegate {
    let errorLabel : UILabel
    let spinner : MONActivityIndicatorView
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        var zeroFrame = frame;
        zeroFrame.origin = CGPointZero
        errorLabel = UILabel(frame: zeroFrame)
        spinner = MONActivityIndicatorView(frame: zeroFrame)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        setBorder(1.0, radius: 5.0)
        
        setTitle("Hit me!", forState: .Normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(30))
        setTitleColor(ThemeColor.primary, forState: .Normal)
        setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        titleLabel?.textAlignment = .Center
        
        errorLabel.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(30))
        errorLabel.textColor = ThemeColor.error
        errorLabel.text = "No drinks for you!"
        errorLabel.textAlignment = .Center
        
        
        spinner.numberOfCircles = 5
        spinner.radius = 6
        spinner.internalSpacing = 15
        spinner.duration = 0.5
        spinner.delay = 0.1
        spinner.delegate = self
        spinner.startAnimating()
        
        addSubview(errorLabel)
        addSubview(spinner)
        self.placeAtCenter(spinner)
        
        setState(.Normal)
    }
    
    
    func show(view: UIView){
        func hideAll(){
            titleLabel?.layer.opacity = 0
            errorLabel.layer.opacity = 0
            spinner.layer.opacity = 0
        }
        
        hideAll()
        view.fadeIn(0.5, options: .CurveEaseIn)
    }
    
    func displayError(errorText: String) {
        errorLabel.text = errorText
        setState(.Error)
    }
    
    func setState(state: StartPouringButtonState) {
        switch state {
            case .Normal:
                enabled = true
                setBorder(color: ThemeColor.primary.CGColor)
                show(titleLabel!)
            case .Loading:
                enabled = false
                setBorder(color: ThemeColor.primary.CGColor)
                show(spinner)
            case .Error:
                enabled = false
                setBorder(color: ThemeColor.error.CGColor)
                show(errorLabel)
                let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                    Int64(1.5 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.setState(.Normal)
                }
        }
    }
    
    func activityIndicatorView(activityIndicatorView: MONActivityIndicatorView!, circleBackgroundColorAtIndex index: UInt) -> UIColor! {
        return ThemeColor.primary
    }

}
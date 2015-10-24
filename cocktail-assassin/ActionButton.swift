import UIKit
import MONActivityIndicatorView

enum StartPouringButtonState {
    case Normal
    case Loading
    case Error
}

class ActionButton: UIButton, MONActivityIndicatorViewDelegate {
    let errorLabel: UILabel
    let spinner: MONActivityIndicatorView
    
    required init?(coder aDecoder: NSCoder) {
        errorLabel = UILabel(frame: CGRectZero)
        spinner = MONActivityIndicatorView(frame: CGRectZero)
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        errorLabel = UILabel(frame: CGRectZero)
        spinner = MONActivityIndicatorView(frame: CGRectZero)
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        backgroundColor = UIColor.clearColor()
        setBorder(1.0, radius: 5.0)
        
        setTitle("Hit me!", forState: .Normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(30))
        setTitleColor(ThemeColor.primary, forState: .Normal)
        setTitleColor(ThemeColor.highlighted, forState: .Highlighted)
        titleLabel?.textAlignment = .Center
        
        errorLabel.frame = CGRect(origin: CGPointZero, size: CGSize(width: 350, height: 48))
        errorLabel.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(30))
        errorLabel.textColor = ThemeColor.error
        errorLabel.text = "No drinks for you!"
        errorLabel.textAlignment = .Center

        spinner.frame = CGRect(origin: CGPointZero, size: CGSize(width: 350, height: 48))
        spinner.numberOfCircles = 5
        spinner.radius = 6
        spinner.internalSpacing = 15
        spinner.duration = 0.5
        spinner.delay = 0.1
        spinner.delegate = self
        spinner.startAnimating()
        spinner.center = self.center
        
        addSubview(errorLabel)
        addSubview(spinner)
        self.placeAtCenter(spinner)
        
        setState(.Normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        errorLabel.frame = errorLabel.frame.setSize(frame.size)
        spinner.frame = spinner.frame.setSize(frame.size)
    }
    
    func show(view: UIView){
        setTitle(view == titleLabel ? "Hit me!" : "", forState: .Normal)
        errorLabel.alpha = 0.0
        spinner.alpha = 0.0
        
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
                setBorder(ThemeColor.primary.CGColor)
                show(titleLabel!)
            case .Loading:
                enabled = false
                setBorder(ThemeColor.primary.CGColor)
                show(spinner)
            case .Error:
                enabled = false
                setBorder(ThemeColor.error.CGColor)
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
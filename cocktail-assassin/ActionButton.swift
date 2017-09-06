import UIKit
import MONActivityIndicatorView

enum StartPouringButtonState {
    case normal
    case loading
    case error
}

class ActionButton: UIButton, MONActivityIndicatorViewDelegate {
    let errorLabel: UILabel
    let spinner: MONActivityIndicatorView
    
    required init?(coder aDecoder: NSCoder) {
        errorLabel = UILabel(frame: CGRect.zero)
        spinner = MONActivityIndicatorView(frame: CGRect.zero)
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        errorLabel = UILabel(frame: CGRect.zero)
        spinner = MONActivityIndicatorView(frame: CGRect.zero)
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        backgroundColor = UIColor.clear
        setBorder(1.0, radius: 5.0)
        
        setTitle("Hit me!", for: UIControlState())
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(30))
        setTitleColor(ThemeColor.primary, for: UIControlState())
        setTitleColor(ThemeColor.highlighted, for: .highlighted)
        titleLabel?.textAlignment = .center
        
        errorLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 350, height: 48))
        errorLabel.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(30))
        errorLabel.textColor = ThemeColor.error
        errorLabel.text = "No drinks for you!"
        errorLabel.textAlignment = .center

        spinner.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 350, height: 48))
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
        
        setState(.normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        errorLabel.frame = errorLabel.frame.setSize(frame.size)
        spinner.frame = spinner.frame.setSize(frame.size)
    }
    
    func show(_ view: UIView){
        setTitle(view == titleLabel ? "Hit me!" : "", for: UIControlState())
        errorLabel.alpha = 0.0
        spinner.alpha = 0.0
        
        view.fadeIn(0.5, options: .curveEaseIn)
    }
    
    func displayError(_ errorText: String) {
        errorLabel.text = errorText
        setState(.error)
    }
    
    func setState(_ state: StartPouringButtonState) {
        switch state {
            case .normal:
                isEnabled = true
                setBorder(ThemeColor.primary.cgColor)
                show(titleLabel!)
            case .loading:
                isEnabled = false
                setBorder(ThemeColor.primary.cgColor)
                show(spinner)
            case .error:
                isEnabled = false
                setBorder(ThemeColor.error.cgColor)
                show(errorLabel)
                let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.setState(.normal)
                }
        }
    }
    
    func activityIndicatorView(_ activityIndicatorView: MONActivityIndicatorView!, circleBackgroundColorAt index: UInt) -> UIColor! {
        return ThemeColor.primary
    }

}

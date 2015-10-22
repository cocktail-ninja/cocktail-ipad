import UIKit

class FixedIncrementSlider: UIControl {
    var slider: UISlider!
    var increment: Float = 1
    var value: Float {
        set {
            setValue(newValue, animated: false)
        }
        get {
            return slider.value * increment
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        addSlider()
    }
    
    func addSlider() {
        let size = CGSize(width: frame.size.width, height: 32)
        slider = UISlider(frame: CGRect(origin: CGPointZero, size: size))
        slider.addTarget(self, action: "sliderChanged", forControlEvents: .ValueChanged)
        addSubview(slider)
        self.layoutSubviews()
    }
    
    func setConfig(minimumValue minimumValue: Float, maximumValue: Float, increment: Float) {
        self.increment = increment
        slider.minimumValue = minimumValue / increment
        slider.maximumValue = maximumValue / increment
    }
    
    func sliderChanged() {
        value = floor(slider.value) * increment
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func setValue(value: Float, animated: Bool) {
        slider.setValue(value / increment, animated: animated)
    }

}
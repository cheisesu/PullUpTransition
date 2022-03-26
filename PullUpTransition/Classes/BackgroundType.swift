import UIKit

/// Type of background behind the presented controller
public enum BackgroundType {
    /// Without background
    case none
    /// Background by passed color
    case color(UIColor)
    /// Background by passed view
    case custom(UIView)
}


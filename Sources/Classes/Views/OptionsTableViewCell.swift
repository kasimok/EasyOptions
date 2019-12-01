import UIKit

open class OptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leadingImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var trailingImageView: UIImageView!
    
    public func configureCellWith(option: ToolbarOption) {
        self.leadingImageView.image = option.icon
        self.label.text = option.name
        self.trailingImageView.image = option.accessoryIcon
    }
    
}

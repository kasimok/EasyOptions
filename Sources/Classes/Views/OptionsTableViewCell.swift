import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leadingImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var trailingImageView: UIImageView!
    
    func configureCellWith(option: ToolbarOption, currentOption: ToolbarOption?, tintColor: UIColor) {
        self.leadingImageView.image = option.icon
        self.leadingImageView.tintColor = tintColor
        self.label.text = option.name
        self.trailingImageView.image = ImageUtils.imageOfCheckMark
        if let current = currentOption, current.name == option.name{
            self.trailingImageView.isHidden = false
        }else{
            self.trailingImageView.isHidden = true
        }
    }
    
}

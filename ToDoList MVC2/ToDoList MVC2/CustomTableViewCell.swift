//
//  CustomTableViewCell.swift
//  ToDoList MVC2
//
//  Created by Тимур Гарипов on 09.09.22.
//

import UIKit

protocol CustomCellDelegate {
    func editCell(cell: CustomTableViewCell)
 //   func deleteCell(cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMarkbtn: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
    @IBAction func chekMarkButtonAction(_ sender: UIButton) {
     
        let selected: UIImage = UIImage(systemName: "circle")!
        let deselected: UIImage = UIImage(systemName: "checkmark.circle.fill")!
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            checkMarkbtn.setImage(deselected, for: .normal)
            taskLabel.attributedText = strikeText(strike: taskLabel.text!)
        }else{
            checkMarkbtn.setImage(selected, for: .normal)
            taskLabel.attributedText = removeStrikeThrough(strike: taskLabel.text!)
            
        }
  
    }
    func strikeText(strike: String) -> NSMutableAttributedString{
        
        let attributeString = NSMutableAttributedString(string: strike)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    func removeStrikeThrough(strike: String) -> NSAttributedString {
            let attributeString = NSMutableAttributedString(string: strike)
        
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            return attributeString
        }
   
                                                          
    
}

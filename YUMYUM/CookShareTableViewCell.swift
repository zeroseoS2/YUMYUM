//
//  MyRecipeTableViewCell.swift
//  YUMYUM
//
//  Created by 최영서 on 6/15/24.
//

import UIKit

class CookShareTableViewCell: UITableViewCell {

    @IBOutlet weak var menuimg: UIImageView!
    @IBOutlet weak var menutitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

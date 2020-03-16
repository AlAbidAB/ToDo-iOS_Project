//
//  todoCell.swift
//  Todo
//
//  Created by Abid AB on 20/2/20.
//  Copyright © 2020 Abid AB. All rights reserved.
//

import UIKit

class todoTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var todoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

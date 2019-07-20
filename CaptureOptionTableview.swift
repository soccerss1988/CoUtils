//
//  CaptureOptionTableview.swift
//  CoUtiles
//
//  Created by YJ Huang on 2019/7/20.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

open class CaptureOptionTableview: UIView {
    @IBOutlet weak var tableview: UITableView!
    var optionalList : Array<Any>?
    var selectCell :
    
    public func newsinstace(owner: Any) -> CaptureOptionTableview {
        return UINib(nibName: "CaptureOptionTableview", bundle: nil).instantiate(withOwner: owner, options: nil).last as! CaptureOptionTableview
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension CaptureOptionTableview : UITableViewDelegate, UITableViewDataSource {
    
   public func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionalList?.count ?? 0
    }
    
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

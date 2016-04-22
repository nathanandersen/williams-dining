//
//  DefaultTableViewHeaderImplementer.swift
//  williams-dining
//
//  Created by Nathan Andersen on 7/1/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation
import UIKit

public class DefaultTableViewController: ColoredStatusBarViewController {

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = Style.defaultColor
        header.textLabel!.textColor = Style.secondaryColor
        header.alpha = 0.9
    }
}

public class MenuDisplayViewController: DefaultTableViewController {
    @IBOutlet var tableView: UITableView?
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var titleLabel: UILabel!

    @IBAction func refreshButtonWasClicked(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async(execute: {
            self.titleLabel.alpha = 1;
            UIView.animate(withDuration: 0.6, delay: 0, options: [UIViewAnimationOptions.autoreverse], animations: {self.titleLabel.alpha = 0}, completion: {(result) -> () in self.titleLabel.alpha = 1})
        })
        (UIApplication.shared.delegate as! AppDelegate).updateData()

    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "FoodItemViewCell", bundle: nil)
        self.tableView!.register(nib, forCellReuseIdentifier: "FoodItemViewCell")
    }

    func refreshTable() {
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
        })
    }

    
}

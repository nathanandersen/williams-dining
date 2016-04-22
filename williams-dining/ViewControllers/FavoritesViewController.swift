//
//  FavoritesViewController.swift
//  williams-dining
//
//  Created by Nathan Andersen on 4/30/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation
import UIKit

public class FavoritesViewController: DefaultTableViewController {
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var favoriteFoodTextField: UITextField!

    var selectedIndexPath: IndexPath?

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(FavoritesViewController.reloadTable), name: reloadFavoritesTableKey, object: nil)
        self.reloadTable()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: reloadFavoritesTableKey, object: nil)
        self.reloadTable()
    }

    func reloadTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

}

extension FavoritesViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text?.trimmingCharacters(in: CharacterSet.alphanumerics.inverted) {
            if text == "" {
                return false
            }
            FavoritesHandler.addItemToFavorites(name: text)
        }
        textField.text = ""
        favoriteFoodTextField.resignFirstResponder()

        return true
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {

    /*
     UITableView functions
     */

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesHandler.getFavorites().count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favorites = FavoritesHandler.getFavorites()

/*
        if indexPath == self.selectedIndexPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedFavoriteTVC") as! SelectedFavoritesTableViewCell

            let selectedFavorite = favorites[indexPath.row]

            // Display other information as appropriate

            cell.nameLabel.text = selectedFavorite

            return cell
        } else {*/
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell") as! FavoritesTableViewCell
            cell.nameLabel.text = favorites[indexPath.row]
            return cell
//        }
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = FavoritesHandler.getFavorites()[indexPath.row]
            FavoritesHandler.removeItemFromFavorites(name: favorite)
            // Update this interface

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
/*        if indexPath == self.selectedIndexPath {
            return 100
        }*/
        return 40
    }
/*
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndexPath == indexPath {
            self.selectedIndexPath = nil
        } else {
            self.selectedIndexPath = indexPath
        }
        self.reloadTable()

    }*/



}

//
//  SearchMemberVC.swift
//  todolistURLPlus
//
//  Created by 陳冠諭 on 2020/9/15.
//  Copyright © 2020 Alvin Tseng. All rights reserved.
//

import UIKit

class SearchMemberVC: UIViewController {
    //MARK:- Properties
    
    var name = ["aa","bb","cc"]
    var mySearchBar = UISearchBar()
    

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setSearchBar()
        navigationItem.titleView = mySearchBar
    }
    //MARK:- Func
    fileprivate func setSearchBar(){
        mySearchBar.delegate = self
        mySearchBar.becomeFirstResponder()
        mySearchBar.placeholder = "Search"
    }

}

extension SearchMemberVC:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}


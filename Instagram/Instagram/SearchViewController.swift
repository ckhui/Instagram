//
//  SearchViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
   
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
/*-------------------------------------------------------*/
    //TOP Button
    @IBOutlet weak var topButton: UIButton! {
        didSet {
            
        topButton.addTarget(self, action: #selector(onTopButtonTapped(button:)), for: .touchUpInside)
                
                
      }
    }
    
    //Top Button Action
    @objc private func onTopButtonTapped(button: UIButton){
    
    }
    
/*-------------------------------------------------------*/
    //PEOPLE Button
    @IBOutlet weak var peopleButton: UIButton! {
        didSet {
            peopleButton.addTarget(self, action: #selector(onPeopleButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    //People Button Action
    @objc private func onPeopleButtonTapped(button: UIButton){
        
    }
    
    
/*-------------------------------------------------------*/
    //TAG Button
    @IBOutlet weak var tagButton: UIButton! {
        didSet {
            tagButton.addTarget(self, action: #selector(onTagButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    //Tag Button Action
    @objc private func onTagButtonTapped(button: UIButton){
        
    }
  
    }

/*-------------------------------------------------------*/
//TableView Delegate
extension SearchViewController: UITableViewDelegate {

}


/*-------------------------------------------------------*/
//TableView DataSource

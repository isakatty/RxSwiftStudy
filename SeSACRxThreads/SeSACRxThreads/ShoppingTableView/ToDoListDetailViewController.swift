//
//  ToDoListDetailViewController.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/5/24.
//

import UIKit

final class ToDoListDetailViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("화면")
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        
    }
    private func configureLayout() {
        view.backgroundColor = .systemPink
        let safeArea = view.safeAreaLayoutGuide
        
    }
}

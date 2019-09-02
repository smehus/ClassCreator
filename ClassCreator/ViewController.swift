//
//  ViewController.swift
//  ClassCreator
//
//  Created by Scott Mehus on 8/27/19.
//  Copyright © 2019 Scott Mehus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        let originalSelector = #selector(ViewController.viewWillAppear(_:))
        let replacementSelector = #selector(myViewWillAppear(animated:))

        let originalMethod = class_getInstanceMethod(ViewController.self, originalSelector)
        let replacementMethod = class_getInstanceMethod(type(of: self), replacementSelector)

        let didAddMethod = class_addMethod(ViewController.self, originalSelector, method_getImplementation(replacementMethod!), method_getTypeEncoding(replacementMethod!))

        if didAddMethod {
            class_replaceMethod(ViewController.self, replacementSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, replacementMethod!);
        }
    }

    @objc func myViewWillAppear(animated: Bool) {
        print("*** hYEYEYEYEYEYOO IT WORKS")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("wtffff")
    }
}

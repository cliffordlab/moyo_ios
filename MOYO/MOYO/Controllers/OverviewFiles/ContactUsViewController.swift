//
//  ContactUsViewController.swift
//  MOYO
//
//  Created by Corey S on 9/19/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import WebKit


class ContactUsViewController: UIViewController{



    @IBOutlet weak var contactUsWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backAction))

    
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loadWebView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func loadWebView()  {
        contactUsWebView.load(URLRequest(url: URL(string: WEBVIEW_URL)!))
    }


    @objc func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }



    func stopLoading() {
       contactUsWebView.removeFromSuperview()
        self.moveToVC()
    }

    func moveToVC()  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

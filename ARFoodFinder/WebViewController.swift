//
//  WebViewController.swift
//  ARFoodFinder
//
//  Created by Ella on 4/27/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView(frame: UIScreen.main.bounds)
        webView.delegate = self
        view.addSubview(webView)
        if let url = URL(string: "https://apple.com") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

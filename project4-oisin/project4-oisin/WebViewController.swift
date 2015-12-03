//
//  ViewController.swift
//  project4-oisin
//
//  Created by Oisín Lavery on 10/1/15.
//  Copyright © 2015 Oisín Lavery. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

  var webView: WKWebView!
  var progressView: UIProgressView!

  var website: String? {
    didSet {
      self.loadWebsite()
    }
  }

  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidDisappear(animated: Bool) {
    webView.removeObserver(self, forKeyPath: "estimatedProgress")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loadWebsite()

    webView.allowsBackForwardNavigationGestures = true

//    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: "openTapped")

    let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: "reload")

    progressView = UIProgressView(progressViewStyle: .Default)
    progressView.sizeToFit()

    let progressButton = UIBarButtonItem(customView: progressView)

    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.toolbarHidden = false

    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
  }

  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    title = webView.title
  }

  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.URL

    if let host = url!.host {

      if host.rangeOfString(website!) != nil {
        decisionHandler(.Allow)
        return
      }
    }

    decisionHandler(.Cancel)
  }

  func loadWebsite() {

    if let website = self.website {

      let url = NSURL(string: "https://" + website)

      if let webView = self.webView {
        webView.loadRequest(NSURLRequest(URL: url!))
      }
    }
  }

//  func openTapped(){
//    let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)
//
//    ac.addAction(UIAlertAction(title: website, style: .Default, handler: openPage))
//    ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//    presentViewController(ac, animated: true, completion: nil)
//  }

//  func openPage(action: UIAlertAction!) {
//    let url = NSURL(string: "https://" + action.title!)!
//    webView.loadRequest(NSURLRequest(URL: url))
//  }
}


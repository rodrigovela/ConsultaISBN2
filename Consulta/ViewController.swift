//
//  ViewController.swift
//  Consulta
//
//  Created by Rodrigo Velazquez on 28/08/16.
//  Copyright © 2016 Rodrigo Velazquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var isbnTextField: UITextField!
    
    func searchBook(urls: String){
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        let text = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        print(text!)
        infoTextView.text = text! as String
    }
    
    func searchBookAsynch(urls: String) {
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = { (datos:NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            let text = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            print(text!)
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
    }

    @IBAction func clearTextView(sender: AnyObject) {
        infoTextView.text = ""
        isbnTextField.text = ""
    }
    @IBAction func search(sender: AnyObject) {
        let isbn:String = isbnTextField.text!
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
    
        searchBook(urls)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


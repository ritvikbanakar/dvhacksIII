//
//  DrunkVC.swift
//  DVHacks3
//
//  Created by Sid on 3/20/21.
//

import UIKit



class DrunkVC: UIViewController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func callContact(_ sender: Any) {
        var number = defaults.string(forKey: defaultsKeys.friend1_phone)
        number = "tel://" + number!
        var url = URL(string: number!)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func repeatTest(_ sender: Any) {
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

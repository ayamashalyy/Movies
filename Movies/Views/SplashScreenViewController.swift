//
//  SplashScreenViewController.swift
//  Movies
//
//  Created by aya on 22/10/2024.
//

import UIKit
import SwiftyGif


class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gifImageView = UIImageView()
        do {
          let gif = try UIImage(gifName: "example.gif")
             gifImageView.setGifImage(gif)
            } catch {
                 print("Error loading GIF: \(error)")
            }
        
         gifImageView.translatesAutoresizingMaskIntoConstraints = false
         gifImageView.contentMode = .scaleAspectFit
         view.addSubview(gifImageView)
        
        
        
        let label = UILabel()
                label.text = "Welcome to Top Movies"
                label.textAlignment = .center
        
         for family in UIFont.familyNames{
            let name = UIFont.fontNames(forFamilyName: family)
            print("family = \(family) - name = \(name))")
          }
                label.font = UIFont(name: "Palatino-BoldItalic", size: 24)
        
                label.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(label)
    

        NSLayoutConstraint.activate([
                    gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    gifImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
                    gifImageView.widthAnchor.constraint(equalToConstant: 150),
                    gifImageView.heightAnchor.constraint(equalToConstant: 150),

                    label.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 20),
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
        
        animateLabel(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.goToHomeScreen()
                }
    }
    
    func animateLabel(_ label: UILabel) {
           
           label.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
           UIView.animate(withDuration: 4.0,
                          delay: 0.0,
                          options: [.curveLinear, .repeat],
                          animations: {
               label.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
           },completion: nil)
    }
    
    func goToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            tabBarController.modalTransitionStyle = .crossDissolve
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }


}

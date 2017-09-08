//
//  customSegue.swift
//  RSR Revalidatieservice
//
//  Created by Diii workstation on 01/08/2017.
//  Copyright © 2017 Diii workstation. All rights reserved.
//

import Foundation
import UIKit

class SegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0) //View movement from 'right to left'
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

class SegueFromLeft: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)  //View movement from left to right
        
        UIView.animate(withDuration: 0.25,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                                   completion: { finished in
                                    src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

//
//  TableViewController.swift
//  DragAndDropTableViewCell
//
//  Created by Ethan Neff on 2/2/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  // controller properties
  var itemsArray : [String]
  
  required init(coder aDecoder: NSCoder) {
    // init controller properties
    itemsArray = ["Advantageous", "Ameliorate", "Cognizant", "Commence", "Commensurate", "Consolidate", "Deleterious", "Disseminate", "Endeavor", "Erroneous", "Expeditious", "Facilitate", "Inception", "Implement", "Leverage", "Optimize", "Prescribed", "Proficiencies", "Promulgate", "Proximity", "Regarding", "Remuneration", "Subsequently"]
    
    super.init(coder: aDecoder)!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // nav controller properties
    navigationController?.navigationBarHidden = true
    
    // table properties
    tableView.contentInset = UIEdgeInsetsZero
    tableView.separatorInset = UIEdgeInsetsZero
    tableView.scrollIndicatorInsets = UIEdgeInsetsZero
    tableView.layoutMargins = UIEdgeInsetsZero
    tableView.tableFooterView = UIView(frame: CGRectZero)
    
    // table guestures
    let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
    longpress.minimumPressDuration = 0.35
    tableView.addGestureRecognizer(longpress)
  }
  
  func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
    // long press on cell
    let longPress = gestureRecognizer as! UILongPressGestureRecognizer
    let state = longPress.state
    let locationInView = longPress.locationInView(tableView)
    let indexPath = tableView.indexPathForRowAtPoint(locationInView)
    
    struct My {
      static var cellSnapshot : UIView? = nil
    }
    struct Path {
      static var initialIndexPath : NSIndexPath? = nil
    }
    
    switch state {
      
    case UIGestureRecognizerState.Began:
      // pick up cell
      if indexPath != nil {
        Path.initialIndexPath = indexPath
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        var center = cell.center
        
        // create the pick-up cell
        My.cellSnapshot = snapshopOfCell(cell)
        My.cellSnapshot!.center = center
        My.cellSnapshot!.alpha = 0.0
        tableView.addSubview(My.cellSnapshot!)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
          center.y = locationInView.y
          // pick up cell
          My.cellSnapshot!.center = center
          My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
          My.cellSnapshot!.alpha = 0.8
          
          // hide old cell (will be there the entire time)
          cell.alpha = 0.0
          
          }, completion: { (finished) -> Void in
            if finished {
              cell.hidden = true
            }
        })
      }
    case UIGestureRecognizerState.Changed:
      // move cell
      var center = My.cellSnapshot!.center
      center.y = locationInView.y
      My.cellSnapshot!.center = center
      if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
        // update items array
        swap(&itemsArray[indexPath!.row], &itemsArray[Path.initialIndexPath!.row])
        // update tableview (move the hidden cell below the hoving cell)
        tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
        // where the cell is hovering over
        Path.initialIndexPath = indexPath
      }
    default:
      // place cell down (unhide the hidden cell)
      let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
      cell.hidden = false
      cell.alpha = 0.0
      UIView.animateWithDuration(0.25, animations: { () -> Void in
        My.cellSnapshot!.center = cell.center
        My.cellSnapshot!.transform = CGAffineTransformIdentity
        My.cellSnapshot!.alpha = 0.0
        cell.alpha = 1.0
        }, completion: { (finished) -> Void in
          if finished {
            Path.initialIndexPath = nil
            My.cellSnapshot!.removeFromSuperview()
            My.cellSnapshot = nil
            print(self.itemsArray)
          }
      })
    }
  }
  
  func snapshopOfCell(inputView: UIView) -> UIView {
    // the pick up cell (view properties)
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
    inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
    UIGraphicsEndImageContext()
    let cellSnapshot : UIView = UIImageView(image: image)
    cellSnapshot.layer.masksToBounds = false
    cellSnapshot.layer.cornerRadius = 0.0
    cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
    cellSnapshot.layer.shadowRadius = 3.0
    cellSnapshot.layer.shadowOpacity = 0.4
    return cellSnapshot
  }
  
  // MARK: - Table view data source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemsArray.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    
    // cell properties
    cell.separatorInset = UIEdgeInsetsZero
    cell.layoutMargins = UIEdgeInsetsZero
    cell.selectionStyle = .None
    cell.textLabel?.text = itemsArray[indexPath.row]
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
}

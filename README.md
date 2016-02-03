# iOS-Swift-Drag-And-Drop-TableView-Cell-1

**purpose** better user experience for reordering a list.

**vision** able to reorder table view cells based on drag and drop gesture.

**methodology** coded in Swift, uses UILongPressGestureRecognizer to make the cell invisible, reorders the cells based on movement, and has a hovering snapshot cell above the TableView to emulate the user interaction. 

**status** this solution only works well for small lists. if you need to drag and drop a cell while scrolling down the TableView, please [use this solution instead](https://github.com/ethanneff/iOS-Swift-Drag-And-Drop-TableView-Cell-3).


![image](http://i.imgur.com/YH1AEdm.gif)

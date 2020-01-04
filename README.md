# ToDo app using TDD

### Description

ToDO is a simple to-do list app


### Task list view

When starting the app, the user sees a list of to-do items. The items in the list consist of a title, an optional location, and the due date. New items can be added to the list by an add (+) button, which is shown in the navigation bar of the view. The task list view will look like this:

<p align="center">
  <img src="https://github.com/cesar-paiva/tdd-with-swift/blob/master/task_list_view.png?raw=true" height="500">
</p>

In a to-do list app, the user will obviously need to be able to check items when they are finished. The checked items are shown below the unchecked items, and it is possible to uncheck them again. Checked items will be put at the end of the list in a section with the Done header. The UI for the to-do item list will look like this:

<p align="center">
  <img src="https://github.com/cesar-paiva/tdd-with-swift/blob/master/task_list_view2.png?raw=true" height="500">
</p>

### Task detail view

The tasks detail view shows all the information that's stored for a to-do item.
The information consists of a title, due date, location (name and address), and a description. If an address is given, a map with an address is shown. The detail view also allows checking the item as finished. The detail view looks like this:

<p align="center">
  <img src="https://github.com/cesar-paiva/tdd-with-swift/blob/master/task_detail_view.png?raw=true" height="500">
</p>

### Task input view

When the user selects the add (+) button in the list view, the task input view is shown. The user can add information for the task. Only the title is required. The Save button can only be selected when a title is given. It is not possible to add a task that is already in the list. The Cancel button dismisses the view. The task input view will look like this:

<p align="center">
  <img src="https://github.com/cesar-paiva/tdd-with-swift/blob/master/task_input_view.png?raw=true" height="500">
</p>

### Application Architecture

<p align="center">
  <img src="https://github.com/cesar-paiva/tdd-with-swift/blob/master/architecture.png?raw=true" height="500">
</p>


## Requirements
- Xcode 10.2.1
- iOS 11
- Swift 4.2

## How to use
Just download source code and unzip the downloaded folder and open project in Xcode.

**Using Terminal:**
```
  git clone https://github.com/cesar-paiva/tdd-with-swift.git
  ```

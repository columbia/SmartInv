1 /**
2  *  The Consumer Contract Wallet
3  *  Copyright (C) 2018 The Contract Wallet Company Limited
4  *
5  *  This program is free software: you can redistribute it and/or modify
6  *  it under the terms of the GNU General Public License as published by
7  *  the Free Software Foundation, either version 3 of the License, or
8  *  (at your option) any later version.
9 
10  *  This program is distributed in the hope that it will be useful,
11  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
12  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  *  GNU General Public License for more details.
14 
15  *  You should have received a copy of the GNU General Public License
16  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
17  */
18 
19 pragma solidity ^0.4.25;
20 
21 /// @title The Controller interface provides access to an external list of controllers.
22 interface IController {
23     function isController(address) external view returns (bool);
24 }
25 
26 /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
27 contract Controller is IController {
28     event AddedController(address _sender, address _controller);
29     event RemovedController(address _sender, address _controller);
30 
31     mapping (address => bool) private _isController;
32     uint private _controllerCount;
33 
34     /// @dev Constructor initializes the list of controllers with the provided address.
35     /// @param _account address to add to the list of controllers.
36     constructor(address _account) public {
37         _addController(_account);
38     }
39 
40     /// @dev Checks if message sender is a controller.
41     modifier onlyController() {
42         require(isController(msg.sender), "sender is not a controller");
43         _;
44     }
45 
46     /// @dev Add a new controller to the list of controllers.
47     /// @param _account address to add to the list of controllers.
48     function addController(address _account) external onlyController {
49         _addController(_account);
50     }
51 
52     /// @dev Remove a controller from the list of controllers.
53     /// @param _account address to remove from the list of controllers.
54     function removeController(address _account) external onlyController {
55         _removeController(_account);
56     }
57 
58     /// @return true if the provided account is a controller.
59     function isController(address _account) public view returns (bool) {
60         return _isController[_account];
61     }
62 
63     /// @return the current number of controllers.
64     function controllerCount() public view returns (uint) {
65         return _controllerCount;
66     }
67 
68     /// @dev Internal-only function that adds a new controller.
69     function _addController(address _account) internal {
70         require(!_isController[_account], "provided account is already a controller");
71         _isController[_account] = true;
72         _controllerCount++;
73         emit AddedController(msg.sender, _account);
74     }
75 
76     /// @dev Internal-only function that removes an existing controller.
77     function _removeController(address _account) internal {
78         require(_isController[_account], "provided account is not a controller");
79         require(_controllerCount > 1, "cannot remove the last controller");
80         _isController[_account] = false;
81         _controllerCount--;
82         emit RemovedController(msg.sender, _account);
83     }
84 }
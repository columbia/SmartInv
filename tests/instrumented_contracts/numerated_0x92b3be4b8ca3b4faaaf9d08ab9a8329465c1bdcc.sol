1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title Team Contract
6  * @dev http://www.puzzlebid.com/
7  * @author PuzzleBID Game Team 
8  * @dev Simon<vsiryxm@163.com>
9  */
10 contract Team {
11 
12     address public owner; 
13    
14     struct Admin {
15         bool isAdmin; 
16         bool isDev;
17         bytes32 name; 
18     }
19 
20     mapping (address => Admin) admins;
21 
22     constructor(address _owner) public {
23         owner = _owner;
24     }
25 
26     event OnAddAdmin(
27         address indexed _address, 
28         bool _isAdmin, 
29         bool _isDev, 
30         bytes32 _name
31     );
32     event OnRemoveAdmin(address indexed _address);
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function addAdmin(address _address, bool _isAdmin, bool _isDev, bytes32 _name) external onlyOwner() {
40         admins[_address] = Admin(_isAdmin, _isDev, _name);        
41         emit OnAddAdmin(_address, _isAdmin, _isDev, _name);
42     }
43 
44     function removeAdmin(address _address) external onlyOwner() {
45         delete admins[_address];        
46         emit OnRemoveAdmin(_address);
47     }
48 
49     function isOwner() external view returns (bool) {
50         return owner == msg.sender;
51     }
52 
53     function isAdmin(address _sender) external view returns (bool) {
54         return admins[_sender].isAdmin;
55     }
56 
57     function isDev(address _sender) external view returns (bool) {
58         return admins[_sender].isDev;
59     }
60 
61 }
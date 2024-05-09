1 pragma solidity ^0.4.18;
2 
3 
4 interface whitelist {
5     function setUserCategory(address user, uint category) external;
6 }
7 
8 
9 contract MultiWhitelist {
10     address public owner;
11 
12     function MultiWhitelist(address _owner) public {
13         owner = _owner;
14     }
15     function transferOwner(address _owner) public {
16         require(msg.sender == owner);
17         owner = _owner;
18     }
19     function multisetUserCategory(address[] users, uint category, whitelist listContract) public {
20         require(msg.sender == owner);
21         require(category == 4);
22 
23         for(uint i = 0 ; i < users.length ; i++ ) {
24             listContract.setUserCategory(users[i],category);
25         }
26     }
27 }
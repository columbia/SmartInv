1 pragma solidity ^0.4.18;
2 
3 // @dev Generated and used by the Truffle framework
4 contract Migrations {
5     address public owner;
6     uint256 public last_completed_migration;
7 
8     modifier restricted() {
9         if (msg.sender == owner)
10         _;
11     }
12 
13     function Migrations() public {
14         owner = msg.sender;
15     }
16 
17     function setCompleted(uint256 completed) public restricted {
18         last_completed_migration = completed;
19     }
20 
21     function upgrade(address newAddress) public restricted {
22         Migrations upgraded = Migrations(newAddress);
23         upgraded.setCompleted(last_completed_migration);
24     }
25 }
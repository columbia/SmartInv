1 pragma solidity ^0.4.24;
2 
3 
4 contract Migrations {
5     address public owner;
6     uint public lastCompletedMigration;
7 
8     modifier restricted() {
9         if (msg.sender == owner) {
10             _;
11         }
12     }
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     function setCompleted(uint completed) public restricted {
19         lastCompletedMigration = completed;
20     }
21 
22     function upgrade(address newAddress) public restricted {
23         Migrations upgraded = Migrations(newAddress);
24         upgraded.setCompleted(lastCompletedMigration);
25     }
26 }
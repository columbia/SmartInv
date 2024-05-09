1 // File: contracts/Migrations.sol
2 
3 pragma solidity ^0.5.0;
4 
5 contract Migrations {
6     address public owner;
7     uint public last_completed_migration;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier restricted() {
14         if (msg.sender == owner) _;
15     }
16 
17     function setCompleted(uint completed) public restricted {
18         last_completed_migration = completed;
19     }
20 
21     function upgrade(address new_address) public restricted {
22         Migrations upgraded = Migrations(new_address);
23         upgraded.setCompleted(last_completed_migration);
24     }
25 }
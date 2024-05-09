1 
2 // File: contracts/Migrations.sol
3 
4 pragma solidity ^0.5.2;
5 
6 contract Migrations {
7     address public owner;
8     uint public last_completed_migration;
9 
10     modifier restricted() {
11         if (msg.sender == owner) _;
12     }
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     function setCompleted(uint completed) public restricted {
19         last_completed_migration = completed;
20     }
21 
22     function upgrade(address new_address) public restricted {
23         Migrations upgraded = Migrations(new_address);
24         upgraded.setCompleted(last_completed_migration);
25     }
26 }

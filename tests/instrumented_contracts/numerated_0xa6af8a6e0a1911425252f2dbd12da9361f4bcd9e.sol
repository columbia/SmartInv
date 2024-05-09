1 // File: contracts/Migrations.sol
2 
3 pragma solidity ^0.5.4;
4 
5 /* solium-disable */
6 
7 contract Migrations {
8     address public owner;
9     uint public last_completed_migration;
10 
11     modifier restricted() {
12         if (msg.sender == owner) _;
13     }
14 
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     function setCompleted(uint completed) public restricted {
20         last_completed_migration = completed;
21     }
22 
23     function upgrade(address new_address) public restricted {
24         Migrations upgraded = Migrations(new_address);
25         upgraded.setCompleted(last_completed_migration);
26     }
27 }
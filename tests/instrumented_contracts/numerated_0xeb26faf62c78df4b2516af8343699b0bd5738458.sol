1 
2 // File: contracts/Migrations.sol
3 
4 pragma solidity ^0.5.4;
5 
6 /* solium-disable */
7 
8 contract Migrations {
9     address public owner;
10     uint public last_completed_migration;
11 
12     modifier restricted() {
13         if (msg.sender == owner) _;
14     }
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     function setCompleted(uint completed) public restricted {
21         last_completed_migration = completed;
22     }
23 
24     function upgrade(address new_address) public restricted {
25         Migrations upgraded = Migrations(new_address);
26         upgraded.setCompleted(last_completed_migration);
27     }
28 }

1 pragma solidity ^0.4.23;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   constructor() public {
8     owner = msg.sender;
9   }
10 
11   modifier restricted() {
12     if (msg.sender == owner) _;
13   }
14 
15   function setCompleted(uint completed) public restricted {
16     last_completed_migration = completed;
17   }
18 
19   function upgrade(address new_address) public restricted {
20     Migrations upgraded = Migrations(new_address);
21     upgraded.setCompleted(last_completed_migration);
22   }
23 }
1 pragma solidity ^0.4.17;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   modifier restricted() {
8     if (msg.sender == owner) _;
9   }
10 
11   function Migrations() public {
12     owner = msg.sender;
13   }
14 
15 // set completed butts
16   function setCompleted(uint completed) public restricted {
17     last_completed_migration = completed;
18   }
19 
20   function upgrade(address new_address) public restricted {
21     Migrations upgraded = Migrations(new_address);
22     upgraded.setCompleted(last_completed_migration);
23   }
24 }
1 pragma solidity ^0.4.15;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   modifier restricted() {
8     if (msg.sender == owner)
9     _;
10   }
11 
12   function Migrations() public {
13     owner = msg.sender;
14   }
15 
16   function setCompleted(uint completed) restricted public {
17     last_completed_migration = completed;
18   }
19 
20   function upgrade(address new_address) restricted public {
21     Migrations upgraded = Migrations(new_address);
22     upgraded.setCompleted(last_completed_migration);
23   }
24 }
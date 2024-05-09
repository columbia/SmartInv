1 pragma solidity ^0.4.4;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   modifier restricted() {
8     if (msg.sender == owner) _;
9   }
10 
11   function Migrations() {
12     owner = msg.sender;
13   }
14 
15   function setCompleted(uint completed) restricted {
16     last_completed_migration = completed;
17   }
18 
19   function upgrade(address new_address) restricted {
20     Migrations upgraded = Migrations(new_address);
21     upgraded.setCompleted(last_completed_migration);
22   }
23 }
1 pragma solidity ^0.4.4;
2 
3 // File: contracts/Migrations.sol
4 
5 contract Migrations {
6   address public owner;
7   uint public last_completed_migration;
8 
9   modifier restricted() {
10     if (msg.sender == owner) _;
11   }
12 
13   function Migrations() public {
14     owner = msg.sender;
15   }
16 
17   function setCompleted(uint completed) restricted public {
18     last_completed_migration = completed;
19   }
20 
21   function upgrade(address new_address) restricted public {
22     Migrations upgraded = Migrations(new_address);
23     upgraded.setCompleted(last_completed_migration);
24   }
25 }